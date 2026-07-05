{ pkgs }:
{
  i3 = {
    package = pkgs.i3;
    provides = [ "desktop" ];
    sessionProtocol = "x11";
  };

  sway = {
    package = pkgs.sway;
    provides = [ "desktop" ];
    sessionProtocol = "wayland";
  };

  niri = {
    package = pkgs.niri;
    provides = [ "desktop" ];
    sessionProtocol = "wayland";
  };

  cosmic = {
    package = pkgs.cosmic-comp;
    provides = [ "desktop" ];
    sessionProtocol = "wayland";
  };

  awesome = {
    package = pkgs.awesome;
    provides = [ "desktop" ];
    sessionProtocol = "x11";
  };
}
