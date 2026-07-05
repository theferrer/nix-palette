{
  config,
  lib,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "avahi") {
  services.avahi = {
    enable = true;
    nssmdns4 = lib.mkDefault true;
    openFirewall = lib.mkDefault true;
  };
}
