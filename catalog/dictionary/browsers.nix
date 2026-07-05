{ pkgs }:
{
  chrome = {
    package = pkgs.google-chrome;
    provides = [ "browser" ];
  };

  edge = {
    package = pkgs.microsoft-edge;
    provides = [ "browser" ];
  };

  librewolf = {
    package = pkgs.librewolf;
    provides = [ "browser" ];
  };

  qutebrowser = {
    package = pkgs.qutebrowser;
    provides = [ "browser" ];
  };

}
