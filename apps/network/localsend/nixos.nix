{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
lib.mkIf (canvasLib.isActive config "localsend") {
  environment.systemPackages = [ pkgs.localsend ];
  networking.firewall = {
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };
}
