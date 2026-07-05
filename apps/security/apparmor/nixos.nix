{
  config,
  lib,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "apparmor") {
  security.apparmor = {
    enable = true;
    packages = [ ];
  };
}
