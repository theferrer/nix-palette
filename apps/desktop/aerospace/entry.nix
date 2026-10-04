{ pkgs }:
{
  package = pkgs.aerospace;
  provides = [ "desktop" ];
  # A macOS session is neither Wayland nor X11.
  sessionProtocol = null;
  homeModule = ./home;
}
