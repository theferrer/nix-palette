{
  config,
  lib,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "flatpak") {
  services.flatpak.enable = true;
}
