{
  config,
  lib,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "asusctl") {
  services.asusd.enable = true;
}
