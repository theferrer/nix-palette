{ pkgs }:
{
  package = pkgs.hyprland;
  provides = [ "desktop" ];
  sessionProtocol = "wayland";
  homeModule = ./home;
}
