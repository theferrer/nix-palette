{
  config,
  lib,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "nemo") {
  services.gvfs.enable = true;
  services.udisks2.enable = true;
}
