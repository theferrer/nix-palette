{
  config,
  lib,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "blueman") {
  services.blueman.enable = true;
}
