# Builds the `qwen-server` wrapper: llama-server preconfigured for
# Qwen3.8-27B, with the GPU backend chosen from the host's declared GPUs.
#
# Backend choice is deliberately based on *all* declared GPUs rather than the
# primary one: on a hybrid laptop the primary GPU is the integrated one, so
# keying off `primary` would silently drop the discrete card's backend.
{
  pkgs,
  lib,
  gpus ? [ ],
}:
let
  shared = import ./shared.nix;

  vendors = map (g: g.vendor) gpus;
  hasNvidia = builtins.elem "nvidia" vendors;
  hasAmd = builtins.elem "amd" vendors;

  # CUDA is the fastest path on NVIDIA, and notably much better than Vulkan at
  # prompt processing, which dominates agentic coding turns. On AMD we take
  # Vulkan rather than ROCm: it needs no per-generation runtime support, which
  # matters for cards newer than the ROCm in nixpkgs.
  backend =
    if hasNvidia then
      "cuda"
    else if hasAmd then
      "vulkan"
    else
      "cpu";

  llama =
    if backend == "cuda" then
      pkgs.llama-cpp.override { cudaSupport = true; }
    else if backend == "vulkan" then
      pkgs.llama-cpp.override { vulkanSupport = true; }
    else
      pkgs.llama-cpp;

  # The chat template shipped inside the official Qwen 3.8 GGUFs wraps every
  # assistant turn in empty <think></think> blocks, which aborts multi-turn
  # agent loops, and defaults reasoning_effort to `xhigh`, which burns the
  # token budget on trivial prompts. This community template fixes both and
  # covers Qwen 3.5/3.6/3.8. Pinned by commit so it cannot shift underneath us.
  chatTemplate = pkgs.fetchurl {
    url = "https://huggingface.co/froggeric/Qwen-Fixed-Chat-Templates/resolve/492315ea6d7343bcfb32598d6a898c34e0d69ed8/chat_template.jinja";
    hash = "sha256-bhQ5yROtffSpZkk61w3n5/xaVI1Bu+QXwVcfdmYDYps=";
  };
in
pkgs.writeShellApplication {
  name = "qwen-server";

  runtimeInputs = [
    llama
    pkgs.gawk
  ];

  meta = {
    description = "llama-server preconfigured for Qwen3.8-27B (${backend} backend)";
    mainProgram = "qwen-server";
  };

  text = ''
    models_dir="''${QWEN_MODEL_DIR:-$HOME/${shared.modelSubdir}}"
    model="$models_dir/${shared.modelFile}"
    mtp="$models_dir/${shared.mtpFile}"

    ctx="''${QWEN_CTX:-${toString shared.contextSize}}"
    port="''${QWEN_PORT:-${toString shared.port}}"
    # The template understands low | medium | xhigh. `medium` is the sane
    # default: Qwen's own `xhigh` overthinks simple prompts for minutes.
    effort="''${QWEN_EFFORT:-medium}"

    if [ ! -f "$model" ] || [ ! -f "$mtp" ]; then
      echo "qwen-server: missing GGUFs in $models_dir" >&2
      echo "" >&2
      echo "They are ~15 GB, so they are not in the Nix store. Fetch them once:" >&2
      echo "" >&2
      echo "  mkdir -p $models_dir && cd $models_dir" >&2
      echo "  base=https://huggingface.co/unsloth/Qwen3.8-27B-GGUF/resolve/main" >&2
      echo "  curl -LO \$base/${shared.modelFile}" >&2
      echo "  curl -L -o ${shared.mtpFile} \$base/MTP/${shared.mtpFile}" >&2
      echo "" >&2
      echo "Do NOT fetch the mmproj file: it is the vision tower, useless for" >&2
      echo "coding, and it forces layers onto the CPU." >&2
      exit 1
    fi

    ${lib.optionalString (backend != "cuda") ''
      # Vulkan enumerates every GPU including integrated ones, and the order is
      # not stable, so pick the device with the most VRAM rather than an index.
      # CUDA needs none of this: it only ever sees NVIDIA cards.
      device="''${QWEN_DEVICE:-}"
      if [ -z "$device" ]; then
        device=$(llama-server --list-devices 2>/dev/null | gawk '
          match($0, /^[[:space:]]+([A-Za-z0-9_]+):.*\(([0-9]+) MiB/, m) {
            if (m[2] + 0 > best) { best = m[2] + 0; dev = m[1] }
          }
          END { if (dev != "") print dev }
        ') || true
      fi
      if [ -z "$device" ]; then
        echo "qwen-server: no GPU device reported by llama-server" >&2
        llama-server --list-devices >&2 || true
        exit 1
      fi
      set -- --device "$device" --spec-draft-device "$device" "$@"
    ''}

    exec llama-server \
      --model "$model" \
      --n-gpu-layers 999 \
      --spec-draft-model "$mtp" --spec-draft-ngl 999 \
      --spec-type draft-mtp --spec-draft-n-max 2 \
      --flash-attn on \
      --cache-type-k q8_0 --cache-type-v q8_0 \
      --ctx-size "$ctx" --parallel 1 \
      --ubatch-size 1024 \
      --jinja --chat-template-file ${chatTemplate} \
      --reasoning-format deepseek --reasoning-preserve \
      --chat-template-kwargs "{\"reasoning_effort\":\"$effort\"}" \
      --temp 0.6 --top-p 0.95 --top-k 20 --repeat-penalty 1.0 \
      --host 127.0.0.1 --port "$port" \
      --alias ${shared.alias} \
      "$@"
  '';
}
