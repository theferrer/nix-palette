{ pkgs, ... }:
{
  home.packages = [ pkgs.playerctl ];
  # The binary builds on macOS too, but there is no MPRIS to daemonise for.
  services.playerctld.enable = pkgs.stdenv.hostPlatform.isLinux;
}
