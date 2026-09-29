# Builds `comfyui`: the ComfyUI server as one command, plus `comfyui models` to
# fetch the pinned checkpoints in ./models.nix.
#
# nixpkgs has ComfyUI, but its torch is CPU-only unless the whole system is
# built with cudaSupport, and that torch is not in the binary cache -- it would
# compile for hours. Custom nodes also want their own pip requirements. So this
# follows apps/ai/ace-step: the source is pinned in the store and only the
# Python environment is built, once, inside an FHS env at first run.
{
  pkgs,
  lib,
  gpus ? [ ],
}:
let
  version = "0.37.0";

  src = pkgs.fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI";
    tag = "v${version}";
    hash = "sha256-hfpoQsu8xzKHCy2Qqw2BMGsorwizJEuhKXWjUUJzTHs=";
  };

  # Custom nodes are pinned here instead of installed through ComfyUI-Manager,
  # so a working set cannot drift out from under a saved workflow.
  customNodes = {
    # Loads .gguf diffusion models; the 20 B edit model only fits quantized.
    ComfyUI-GGUF = pkgs.fetchFromGitHub {
      owner = "city96";
      repo = "ComfyUI-GGUF";
      rev = "6ea2651e7df66d7585f6ffee804b20e92fb38b8a";
      hash = "sha256-/ZwecgxTTMo9J1whdEJci8lEkOy/yP+UmjbpOAA3BvU=";
    };
  };

  models = import ./models.nix;

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

  # ComfyUI's README requires cu130 or newer on anything from the 20 series up.
  # ROCm 7.2 is what apps/ai/ace-step already runs on the 9070 XT.
  wheelIndex =
    {
      cuda = "https://download.pytorch.org/whl/cu130";
      rocm = "https://download.pytorch.org/whl/rocm7.2";
      cpu = "https://download.pytorch.org/whl/cpu";
    }
    .${backend};

  # One line per file: group, directory, file name, sha256, size, url.
  manifest = pkgs.writeText "comfyui-models.tsv" (
    lib.concatStrings (
      lib.mapAttrsToList (
        group: g:
        lib.concatMapStrings (
          f: "${group}\t${f.dir}\t${f.name}\t${f.sha256}\t${toString f.size}\t${f.url}\n"
        ) g.files
      ) models
    )
  );

  groupHelp = lib.concatStrings (
    lib.mapAttrsToList (group: g: "  ${lib.fixedWidthString 6 " " group}  ${g.description}\n") models
  );

  fetchModels = pkgs.writeShellScript "comfyui-models" ''
    set -euo pipefail
    export PATH=${
      lib.makeBinPath [
        pkgs.coreutils
        pkgs.curl
        pkgs.gawk
      ]
    }
    models="$1"
    shift
    verified="$models/.verified"
    mkdir -p "$verified"

    human() { awk -v b="$1" 'BEGIN { printf "%.1f GB", b / 1e9 }'; }

    if [ $# -eq 0 ] || [ "$1" = list ]; then
      echo "usage: comfyui models <group>... | all"
      echo
      printf '%s' ${lib.escapeShellArg groupHelp}
      echo
      while IFS=$'\t' read -r group dir name sha size url; do
        if [ -e "$verified/$sha" ]; then mark=ok; else mark=--; fi
        printf '  [%s] %-6s %-9s %s\n' "$mark" "$group" "$(human "$size")" "$dir/$name"
      done < ${manifest}
      exit 0
    fi

    want=" $* "
    while IFS=$'\t' read -r group dir name sha size url; do
      case "$want" in *" $group "* | *" all "*) ;; *) continue ;; esac

      dest="$models/$dir/$name"
      if [ -e "$verified/$sha" ] && [ -e "$dest" ]; then
        echo "ok      $dir/$name"
        continue
      fi

      mkdir -p "$models/$dir"
      echo "fetch   $dir/$name ($(human "$size"))"
      # -C - resumes a .part left behind by an interrupted run.
      curl -fL --retry 5 --retry-delay 5 -C - -o "$dest.part" "$url"

      echo "verify  $dir/$name"
      if [ "$(sha256sum "$dest.part" | cut -d' ' -f1)" != "$sha" ]; then
        echo "comfyui models: sha256 mismatch for $name; removing the download" >&2
        rm -f "$dest.part"
        exit 1
      fi
      mv "$dest.part" "$dest"
      touch "$verified/$sha"
    done < ${manifest}
  '';

  nodeLinks = lib.concatStrings (
    lib.mapAttrsToList (name: path: ''
      ln -sfn ${path} "$state/custom_nodes/${name}"
    '') customNodes
  );

  # Tested in the shell, not with pathExists: that would fetch every node at
  # evaluation time.
  nodeRequirements = lib.concatStrings (
    lib.mapAttrsToList (_: path: ''
      if [ -f ${path}/requirements.txt ]; then
        "$venv/bin/pip" install -r ${path}/requirements.txt
      fi
    '') customNodes
  );

  run = pkgs.writeShellScript "comfyui-run-server" ''
    set -euo pipefail

    state="''${COMFYUI_HOME:-''${XDG_DATA_HOME:-$HOME/.local/share}/comfyui}"
    venv="$state/venv"
    mkdir -p "$state"/{models,custom_nodes,input,output,user}

    if [ "''${1:-}" = models ]; then
      shift
      exec ${fetchModels} "$state/models" "$@"
    fi

    # --base-directory keeps every writable path (models, nodes, input, output,
    # user) under $state, so the source can run straight from the store.
    ${nodeLinks}

    # Keyed on the pin, the nodes and the backend: a bump moves the
    # requirements, and a different machine wants different wheels.
    want="${backend}:${src}:${builtins.concatStringsSep ":" (builtins.attrValues customNodes)}"
    if [ "$(cat "$venv/.deps" 2>/dev/null || true)" != "$want" ]; then
      echo "comfyui: building the ${backend} Python environment -- several GB, first run only" >&2
      [ -x "$venv/bin/python" ] || python3.13 -m venv "$venv"
      "$venv/bin/pip" install --upgrade pip wheel
      "$venv/bin/pip" install torch torchvision torchaudio --index-url ${wheelIndex}
      "$venv/bin/pip" install -r ${src}/requirements.txt
      ${nodeRequirements}
      echo "$want" > "$venv/.deps"
    fi

    ${lib.optionalString (backend == "rocm") ''
      # Without this, MIOpen benchmarks every conv kernel on the first VAE
      # decode and the run sits there looking hung for minutes.
      export MIOPEN_FIND_MODE="''${MIOPEN_FIND_MODE:-FAST}"
    ''}

    # --disable-api-nodes drops the paid cloud nodes, and with them the
    # frontend's calls out to the internet: everything here runs locally.
    exec "$venv/bin/python" -u ${src}/main.py \
      --base-directory "$state" \
      --listen "''${COMFYUI_HOST:-127.0.0.1}" \
      --port "''${COMFYUI_PORT:-8188}" \
      --disable-api-nodes \
      "$@"
  '';
in
pkgs.buildFHSEnv {
  name = "comfyui";
  runScript = run;

  targetPkgs =
    p: with p; [
      python313
      git
      curl
      cacert
      # pip still builds a couple of these from source
      gcc
      gnumake
      pkg-config
      # dlopened by the wheels: libstdc++ by torch, libGL/glib by opencv-based
      # nodes, libdrm/numactl/libelf/libtinfo by the ROCm runtime they carry.
      stdenv.cc.cc.lib
      zlib
      zstd
      openssl
      libxml2
      libGL
      glib
      libdrm
      numactl
      elfutils
      ncurses
      ffmpeg
    ];

  meta = {
    description = "ComfyUI ${version} with pinned models (${backend} backend)";
    homepage = "https://github.com/Comfy-Org/ComfyUI";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "comfyui";
  };
}
