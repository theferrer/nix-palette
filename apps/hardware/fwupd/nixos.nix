{
  config,
  lib,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "fwupd") {
  services.fwupd.enable = true;
}
