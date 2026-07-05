{
  config,
  lib,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "plymouth") {
  boot.plymouth.enable = true;
}
