{
  config,
  lib,
  pkgs,
  canvasLib,
  ...
}:
let
  gpus = config.canvas.hardware.gpus;
  primary = lib.findFirst (g: g.primary) (if gpus == [ ] then null else lib.head gpus) gpus;
  vendor = if primary == null then null else primary.vendor;
  package =
    if vendor == "amd" then
      pkgs.ollama-rocm
    else if vendor == "nvidia" then
      pkgs.ollama-cuda
    else
      pkgs.ollama;
in
lib.mkIf (canvasLib.isActive config "ollama") {
  services.ollama = {
    enable = true;
    inherit package;
    host = lib.mkDefault "127.0.0.1";
    port = lib.mkDefault 11434;
  };
}
