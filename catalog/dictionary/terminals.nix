{ pkgs }:
{
  warp = {
    package = pkgs.warp-terminal;
    provides = [ "terminal" ];
  };
  xterm = {
    package = pkgs.xterm;
    provides = [ "terminal" ];
  };
}
