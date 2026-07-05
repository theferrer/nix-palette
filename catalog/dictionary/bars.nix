{ pkgs }:
{
  ags = {
    package = pkgs.ags;
    provides = [ "bar" ];
  };

  quickshell = {
    package = pkgs.quickshell;
    provides = [ "bar" ];
  };

}
