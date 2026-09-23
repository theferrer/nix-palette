# Builds `ace-step`: ACE-Step 1.5, the local music-generation model, as one
# command.
#
# Upstream ships no Nix packaging, and its dependencies are a pip tree that
# wants the PyTorch wheels straight from pytorch.org. That is not laziness on
# our part: the ROCm wheels bundle their own ROCm userspace, which is the only
# way to get a runtime new enough for a card as recent as RDNA4 without waiting
# for nixpkgs. So the source is pinned in the store and only the Python
# environment is built, once, inside an FHS env at first run.
{
  pkgs,
  lib,
  gpus ? [ ],
}:
let
  rev = "ca1e85fe9430179831e6bc6be790c332190a3866";

  src = pkgs.fetchFromGitHub {
    owner = "ace-step";
    repo = "ACE-Step-1.5";
    inherit rev;
    hash = "sha256-2hyCrIRNbRpBY1rhHV/c0Ag4+QFlYshY+4p6kzD3oeo=";
  };

  # Keyed on *all* declared GPUs rather than the primary one, for the same
  # reason as apps/ai/llama-cpp: on a hybrid machine the primary is integrated.
  vendors = map (g: g.vendor) gpus;
  backend =
    if builtins.elem "nvidia" vendors then
      "cuda"
    else if builtins.elem "amd" vendors then
      "rocm"
    else
      "cpu";

  # ROCm 7.2 is the first runtime AMD lists gfx1201 (RDNA4, the 9070 XT) under,
  # and its wheels carry the code objects, so there is deliberately no
  # HSA_OVERRIDE_GFX_VERSION below: upstream's launcher pins it to 11.0.0 for
  # RDNA3, which would make a 9070 XT lie about what it is. The CUDA wheels are
  # what the default index serves, so that case passes no --index-url at all.
  wheelIndex =
    {
      rocm = "--index-url https://download.pytorch.org/whl/rocm7.2";
      cuda = "";
      cpu = "--index-url https://download.pytorch.org/whl/cpu";
    }
    .${backend};

  requirements = if backend == "rocm" then "requirements-rocm-linux.txt" else "requirements.txt";

  run = pkgs.writeShellScript "ace-step-run" ''
    set -euo pipefail

    state="''${ACESTEP_HOME:-''${XDG_DATA_HOME:-$HOME/.local/share}/ace-step}"
    app="$state/app"
    venv="$state/venv"

    # The checkpoints are tens of GB and download themselves on first use, so
    # they sit beside the venv rather than in the default HuggingFace cache.
    export ACESTEP_CHECKPOINTS_DIR="''${ACESTEP_CHECKPOINTS_DIR:-$state/checkpoints}"
    mkdir -p "$state" "$state/outputs" "$ACESTEP_CHECKPOINTS_DIR"

    # The pin is read-only in the store but ACE-Step writes inside its own tree,
    # so it gets copied out once per pin. Generated audio lives outside that copy
    # and is symlinked back in, so bumping the pin cannot throw it away.
    if [ "$(cat "$state/.src" 2>/dev/null || true)" != "${src}" ]; then
      echo "ace-step: unpacking ${builtins.substring 0 7 rev} into $app" >&2
      rm -rf "$app"
      cp -r --no-preserve=mode,ownership "${src}" "$app"
      ln -sfn "$state/outputs" "$app/outputs"
      echo "${src}" > "$state/.src"
      rm -f "$venv/.deps"
    fi

    # Keyed on the pin and the backend both: a source bump moves the requirements,
    # and a different machine wants different wheels.
    want="${backend}:${src}"
    if [ "$(cat "$venv/.deps" 2>/dev/null || true)" != "$want" ]; then
      echo "ace-step: building the ${backend} Python environment -- several GB, first run only" >&2
      [ -x "$venv/bin/python" ] || python3.11 -m venv "$venv"
      "$venv/bin/pip" install --upgrade pip wheel
      "$venv/bin/pip" install torch torchvision torchaudio ${wheelIndex}
      "$venv/bin/pip" install -r "$app/${requirements}"
      echo "$want" > "$venv/.deps"
    fi

    # Taken from upstream's start_gradio_ui_rocm.sh rather than calling it: that
    # script ends in an interactive "update now?" prompt, and the pin is ours.
    export ACESTEP_LM_BACKEND=pt # the vLLM path needs flash-attn, which has no ROCm build
    export TOKENIZERS_PARALLELISM=false
    ${lib.optionalString (backend == "rocm") ''
      # Without this, MIOpen benchmarks every conv kernel on the first VAE decode
      # and the run sits there looking hung for minutes.
      export MIOPEN_FIND_MODE="''${MIOPEN_FIND_MODE:-FAST}"
    ''}

    args=(
      --server-name "''${ACESTEP_HOST:-127.0.0.1}"
      --port "''${ACESTEP_PORT:-7860}"
      --language en
      --backend pt
      --init_service true
      # 1.7B is what upstream's own tier table recommends at 16-20 GB. Their ROCm
      # launcher defaults to the 4B, which only fits with --offload_to_cpu.
      --config_path "''${ACESTEP_CONFIG:-acestep-v15-turbo}"
      --lm_model_path "''${ACESTEP_LM:-acestep-5Hz-lm-1.7B}"
    )

    # ACESTEP_LM=acestep-5Hz-lm-4B ACESTEP_OFFLOAD=1 buys quality at the cost of
    # shuffling the LM across PCIe every generation.
    if [ "''${ACESTEP_OFFLOAD:-0}" = 1 ]; then
      args+=( --offload_to_cpu true )
    fi

    ${lib.optionalString (backend == "rocm") ''
      # Quantization is auto-picked from the GPU tier and lands on int8, whose
      # torchao kernels are a CUDA path; the ROCm manual says to turn it off.
      args+=( --quantization "''${ACESTEP_QUANT:-none}" )
    ''}

    cd "$app"
    exec "$venv/bin/python" -u acestep/acestep_v15_pipeline.py "''${args[@]}" "$@"
  '';
in
pkgs.buildFHSEnv {
  name = "ace-step";
  runScript = run;

  targetPkgs =
    p: with p; [
      python311
      git
      curl
      cacert
      # pip still builds a couple of these from source
      gcc
      gnumake
      pkg-config
      # dlopened by the wheels: libstdc++ by torch, libdrm/numactl/libelf/libtinfo
      # by the ROCm runtime they carry, libsndfile by soundfile (torchcodec has no
      # ROCm build, so soundfile is the audio path).
      stdenv.cc.cc.lib
      zlib
      zstd
      openssl
      libxml2
      libdrm
      numactl
      elfutils
      ncurses
      libsndfile
      ffmpeg
    ];

  meta = {
    description = "ACE-Step 1.5 local music generation (${backend} backend)";
    homepage = "https://github.com/ace-step/ACE-Step-1.5";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "ace-step";
  };
}
