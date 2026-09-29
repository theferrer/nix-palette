"""Queue a ComfyUI workflow, wait for it, and save what it produced.

Built for scripts and agents rather than people: one command, file paths on
stdout, errors on stderr and a non-zero exit when the graph fails.

    comfyui-run workflow.json \\
        --set 6.inputs.text="pixel art knight, side view" \\
        --set 3.inputs.seed=42 \\
        --upload 12.inputs.image=ref.png \\
        --out renders/

Tested starting points live in /run/current-system/sw/share/comfyui/workflows:
z-image-pixel-art.json (text to image) and flux2-klein-edit.json (re-pose or
restyle a reference while keeping the character).

The workflow must be in API format (ComfyUI: Workflow > Export (API)). Values
given to --set are parsed as JSON when they parse, so numbers stay numbers;
anything else is taken as a string.
"""

import argparse
import json
import mimetypes
import os
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
import uuid


def request(url, data=None, headers=None):
    req = urllib.request.Request(url, data=data, headers=headers or {})
    with urllib.request.urlopen(req, timeout=60) as resp:
        return resp.read()


def get_json(base, path):
    return json.loads(request(base + path))


def post_json(base, path, payload):
    body = json.dumps(payload).encode()
    return json.loads(request(base + path, body, {"Content-Type": "application/json"}))


def upload_image(base, path):
    """POST a file to /upload/image and return the name ComfyUI stored it as."""
    boundary = uuid.uuid4().hex
    name = os.path.basename(path)
    ctype = mimetypes.guess_type(name)[0] or "application/octet-stream"
    with open(path, "rb") as f:
        content = f.read()
    body = b"".join([
        f"--{boundary}\r\n".encode(),
        f'Content-Disposition: form-data; name="image"; filename="{name}"\r\n'.encode(),
        f"Content-Type: {ctype}\r\n\r\n".encode(),
        content,
        f"\r\n--{boundary}\r\n".encode(),
        b'Content-Disposition: form-data; name="overwrite"\r\n\r\ntrue',
        f"\r\n--{boundary}--\r\n".encode(),
    ])
    headers = {"Content-Type": f"multipart/form-data; boundary={boundary}"}
    reply = json.loads(request(base + "/upload/image", body, headers))
    sub = reply.get("subfolder")
    return f"{sub}/{reply['name']}" if sub else reply["name"]


def assign(workflow, dotted, value):
    """Set workflow[node][...][key] from a "node.inputs.key" path."""
    node, *keys = dotted.split(".")
    if node not in workflow:
        sys.exit(f"comfyui-run: no node {node!r} in the workflow")
    target = workflow[node]
    for key in keys[:-1]:
        target = target.setdefault(key, {})
    target[keys[-1]] = value


def parse_value(raw):
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        return raw


def split_pair(pair, flag):
    if "=" not in pair:
        sys.exit(f"comfyui-run: {flag} wants NODE.inputs.KEY=VALUE, got {pair!r}")
    return pair.split("=", 1)


def wait_ready(base, timeout):
    deadline = time.time() + timeout
    while True:
        try:
            return get_json(base, "/system_stats")
        except (urllib.error.URLError, ConnectionError):
            if time.time() > deadline:
                sys.exit(f"comfyui-run: nothing answering at {base} (systemctl --user start comfyui)")
            time.sleep(2)


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("workflow", nargs="?", help="API-format workflow JSON")
    parser.add_argument("--set", action="append", default=[], metavar="NODE.inputs.KEY=VALUE")
    parser.add_argument("--upload", action="append", default=[], metavar="NODE.inputs.KEY=FILE",
                        help="upload FILE to ComfyUI's input dir and set the input to its name")
    parser.add_argument("--out", default=".", help="directory for the results (default: .)")
    parser.add_argument("--url", default=os.environ.get("COMFYUI_URL", "http://127.0.0.1:8188"))
    parser.add_argument("--timeout", type=float, default=900, help="seconds to wait for the run")
    parser.add_argument("--ping", action="store_true", help="wait for the server and print its GPU state")
    args = parser.parse_args()
    base = args.url.rstrip("/")

    if args.ping:
        stats = wait_ready(base, args.timeout)
        for dev in stats.get("devices", []):
            free, total = dev.get("vram_free", 0) / 2**30, dev.get("vram_total", 0) / 2**30
            print(f"{dev.get('name')}: {free:.1f} / {total:.1f} GiB VRAM free")
        return

    if not args.workflow:
        parser.error("a workflow is required (or --ping)")

    with open(args.workflow) as f:
        workflow = json.load(f)
    if "nodes" in workflow and "links" in workflow:
        sys.exit("comfyui-run: this is a UI workflow; export it with Workflow > Export (API)")

    wait_ready(base, 60)
    for pair in args.set:
        key, raw = split_pair(pair, "--set")
        assign(workflow, key, parse_value(raw))
    for pair in args.upload:
        key, path = split_pair(pair, "--upload")
        assign(workflow, key, upload_image(base, path))

    client = uuid.uuid4().hex
    try:
        queued = post_json(base, "/prompt", {"prompt": workflow, "client_id": client})
    except urllib.error.HTTPError as e:
        sys.exit(f"comfyui-run: workflow rejected:\n{e.read().decode(errors='replace')}")
    prompt_id = queued["prompt_id"]

    deadline = time.time() + args.timeout
    while True:
        history = get_json(base, f"/history/{prompt_id}").get(prompt_id)
        if history and history.get("status", {}).get("completed") is not None:
            break
        if history and history.get("status", {}).get("status_str") == "error":
            break
        if time.time() > deadline:
            sys.exit(f"comfyui-run: still running after {args.timeout:.0f}s (prompt {prompt_id})")
        time.sleep(1)

    status = history.get("status", {})
    if status.get("status_str") == "error":
        for kind, detail in status.get("messages", []):
            if kind == "execution_error":
                sys.exit(f"comfyui-run: node {detail.get('node_id')} ({detail.get('node_type')}) failed: "
                         f"{detail.get('exception_message', '').strip()}")
        sys.exit("comfyui-run: the run failed")

    os.makedirs(args.out, exist_ok=True)
    saved = 0
    for output in history.get("outputs", {}).values():
        for kind in ("images", "gifs", "videos", "audio", "3d"):
            for item in output.get(kind, []):
                if item.get("type") != "output":
                    continue
                query = urllib.parse.urlencode({
                    "filename": item["filename"],
                    "subfolder": item.get("subfolder", ""),
                    "type": item["type"],
                })
                dest = os.path.join(args.out, item["filename"])
                with open(dest, "wb") as f:
                    f.write(request(f"{base}/view?{query}"))
                print(dest)
                saved += 1
    if saved == 0:
        print("comfyui-run: finished, but no output node saved anything", file=sys.stderr)


if __name__ == "__main__":
    main()
