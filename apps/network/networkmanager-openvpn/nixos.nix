{
  config,
  lib,
  pkgs,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "networkmanager-openvpn") {
  networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
}
