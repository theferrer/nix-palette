{ pkgs }:
{

  flameshot = {
    package = pkgs.flameshot;
    provides = [ "screenshot" ];
  };
}
