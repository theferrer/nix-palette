{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
let
  conf = if osConfig != null then osConfig else config;
  shared = import ../shared.nix;

  qwenServer = import ../package.nix {
    inherit pkgs lib;
    gpus = conf.canvas.hardware.gpus or [ ];
  };
in
{
  # On demand rather than on login: the model pins ~15 GB of VRAM, which is the
  # whole card on a 16 GB GPU, so nothing else could use it meanwhile.
  #   systemctl --user start qwen-server
  systemd.user.services.qwen-server = {
    Unit = {
      Description = "llama-server for local Qwen3.8-27B";
      Documentation = "https://github.com/ggml-org/llama.cpp";
    };
    Service = {
      ExecStart = lib.getExe qwenServer;
      Restart = "no";
      # Loading 13 GB onto the GPU, plus Vulkan shader compilation on the first
      # run, comfortably outlives the default startup timeout.
      TimeoutStartSec = "600";
    };
  };

  # Registers the local server as an opencode provider. The default model is
  # deliberately left alone: this shows up as a choice in /models, it does not
  # take over.
  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    provider.llamacpp = {
      npm = "@ai-sdk/openai-compatible";
      name = "llama.cpp (local)";
      options = {
        baseURL = "http://127.0.0.1:${toString shared.port}/v1";
        # A local 27B on one consumer GPU is far slower than a hosted model:
        # the per-request and inter-chunk timeouts have to allow for prefill on
        # a long context, or opencode gives up mid-turn.
        headerTimeout = false;
        chunkTimeout = 300000;
      };
      models.${shared.alias} = {
        name = "Qwen3.8-27B Q3_K_XL (local)";
        family = "qwen";
        release_date = "2026-08-14";
        attachment = false;
        reasoning = true;
        temperature = true;
        tool_call = true;
        cost = {
          input = 0;
          output = 0;
        };
        limit = {
          context = shared.contextSize;
          output = 8192;
        };
        modalities = {
          input = [ "text" ];
          output = [ "text" ];
        };
      };
    };
  };
}
