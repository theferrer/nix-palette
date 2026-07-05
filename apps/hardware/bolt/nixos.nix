{
  config,
  lib,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "bolt") {
  services.hardware.bolt.enable = true;
}
