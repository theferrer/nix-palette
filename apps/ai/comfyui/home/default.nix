{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
let
  conf = if osConfig != null then osConfig else config;

  comfyui = import ../package.nix {
    inherit pkgs lib;
    gpus = conf.canvas.hardware.gpus or [ ];
  };
in
{
  # On demand rather than on login: a loaded model holds most of a 16 GB card,
  # so it should only be up while something is generating.
  #   systemctl --user start comfyui   # then http://127.0.0.1:8188
  systemd.user.services.comfyui = {
    Unit = {
      Description = "ComfyUI local diffusion server";
      Documentation = "https://docs.comfy.org";
      # Both want the whole card; starting one stops the other instead of
      # letting the second spill into system RAM. A no-op without llama-cpp.
      Conflicts = [ "qwen-server.service" ];
    };
    Service = {
      ExecStart = lib.getExe comfyui;
      Restart = "no";
    };
  };
}
