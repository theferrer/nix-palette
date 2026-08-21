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
    model_file="''${QWEN_MODEL_FILE:-${shared.modelFile}}"
    model="$models_dir/$model_file"
    mtp="$models_dir/${shared.mtpFile}"

    ctx="''${QWEN_CTX:-${toString shared.contextSize}}"
    port="''${QWEN_PORT:-${toString shared.port}}"
    # The template understands low | medium | xhigh. `medium` is the sane
    # default: Qwen's own `xhigh` overthinks simple prompts for minutes.
    effort="''${QWEN_EFFORT:-medium}"

    # On a 16 GB card the weights, the MTP head and the KV cache compete for the
    # same budget, and you can only have two of {4-bit, MTP, headroom}. So both
    # are knobs rather than assumptions:
    #   QWEN_MTP=off      free ~1.3 GiB by dropping speculative decoding
    #   QWEN_NGL=58       leave the last layers on CPU to fit a bigger quant
    # 4-bit is indistinguishable from BF16 where 3-bit is not, so trading some
    # speed for it is a real option on a host with RAM to spare.
    use_mtp="''${QWEN_MTP:-on}"
    ngl="''${QWEN_NGL:-999}"

    if [ ! -f "$model" ]; then
      echo "qwen-server: no $model_file in $models_dir" >&2
      echo "" >&2
      echo "The GGUFs are 12-16 GB, so they are not in the Nix store." >&2
      echo "" >&2
      echo "  mkdir -p $models_dir && cd $models_dir" >&2
      echo "  base=https://huggingface.co/unsloth/Qwen3.8-27B-GGUF/resolve/main" >&2
      echo "  curl -LO \$base/$model_file" >&2
      echo "  curl -L -o ${shared.mtpFile} \$base/MTP/${shared.mtpFile}" >&2
      echo "" >&2
      echo "Do NOT fetch the mmproj file: it is the vision tower, useless for" >&2
      echo "coding, and it forces layers onto the CPU." >&2
      exit 1
    fi

    if [ "$use_mtp" = on ] && [ ! -f "$mtp" ]; then
      echo "qwen-server: MTP head missing, continuing without speculative decoding" >&2
      echo "  (expected $mtp -- costs roughly 1.8x decode speed)" >&2
      use_mtp=off
    fi

    args=(
      --model "$model"
      --n-gpu-layers "$ngl"
      --flash-attn on
      --cache-type-k q8_0 --cache-type-v q8_0
      --ctx-size "$ctx" --parallel 1
      # Prompt processing at the default ubatch of 512 is 5.2x slower, which is
      # what an agentic turn spends most of its wall clock on.
      --ubatch-size 1024
      --jinja --chat-template-file ${chatTemplate}
      --reasoning-format deepseek --reasoning-preserve
      --chat-template-kwargs "{\"reasoning_effort\":\"$effort\"}"
      --temp 0.6 --top-p 0.95 --top-k 20 --repeat-penalty 1.0
      --host 127.0.0.1 --port "$port"
      --alias ${shared.alias}
    )

    if [ "$use_mtp" = on ]; then
      args+=(
        --spec-draft-model "$mtp" --spec-draft-ngl "$ngl"
        --spec-type draft-mtp --spec-draft-n-max 2
      )
    fi

    ${lib.optionalString (backend != "cuda") ''
      # Vulkan enumerates every GPU including integrated ones and the order is
      # not stable, so the device has to be chosen by inspection. CUDA needs
      # none of this: it only ever sees NVIDIA cards.
      #
      # Choose on *free* memory, not total: an integrated GPU reports a slice of
      # system RAM as its own and can out-claim a discrete card (zeph's Arc
      # iGPU advertises 23 GiB against the 4090's 16), which would quietly send
      # the model to the slowest processor in the box. Known integrated and
      # software renderers are skipped by name on top of that.
      device="''${QWEN_DEVICE:-}"
      if [ -z "$device" ]; then
        pick=$(llama-server --list-devices 2>/dev/null | gawk '
          match($0, /^[[:space:]]+([A-Za-z0-9_]+):[[:space:]]*(.+)\(([0-9]+) MiB,[[:space:]]*([0-9]+) MiB free/, m) {
            name = m[2]; sub(/[[:space:]]+$/, "", name)
            free = m[4] + 0
            # Track the best of everything as a fallback, because RADV names
            # chips it does not recognise "AMD Radeon Graphics" -- the same
            # string an APU uses. Excluding by name alone would then throw away
            # a brand-new discrete card and leave nothing.
            if (free > anyfree) { anyfree = free; anydev = m[1]; anyname = name }
            if (name ~ /llvmpipe|UHD|Iris|Intel|Radeon\(TM\) Graphics|Radeon Graphics/) next
            if (free > best) { best = free; dev = m[1]; picked = name }
          }
          END {
            if (dev != "") printf "%s|%s|%d\n", dev, picked, best
            else if (anydev != "") printf "%s|%s, unrecognised name|%d\n", anydev, anyname, anyfree
          }
        ') || true
        device="''${pick%%|*}"
        if [ -n "$device" ]; then
          rest="''${pick#*|}"
          echo "qwen-server: using $device (''${rest%%|*}, ''${rest##*|} MiB free)" >&2
        fi
      fi
      if [ -z "$device" ]; then
        echo "qwen-server: no usable GPU device reported by llama-server" >&2
        echo "  (set QWEN_DEVICE=VulkanN to force one)" >&2
        llama-server --list-devices >&2 || true
        exit 1
      fi
      args+=( --device "$device" )
      if [ "$use_mtp" = on ]; then
        args+=( --spec-draft-device "$device" )
      fi
    ''}

    exec llama-server "''${args[@]}" "$@"
  '';
}
