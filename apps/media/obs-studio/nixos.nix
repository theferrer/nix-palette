{
  config,
  lib,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "obs-studio") {
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = lib.mkDefault true;
}
