{
  config,
  lib,
  pkgs,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "llama-cpp") {
  environment.systemPackages = [
    (import ./package.nix {
      inherit pkgs lib;
      gpus = config.canvas.hardware.gpus;
    })
  ];
}
