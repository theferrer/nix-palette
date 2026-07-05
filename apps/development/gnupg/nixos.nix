{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
lib.mkIf (canvasLib.isActive config "gnupg" && canvasLib.isGraphical config) {
  services.dbus.packages = [ pkgs.gcr ];
}
