{
  config,
  lib,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "droidcam") {
  programs.droidcam.enable = true;
}
