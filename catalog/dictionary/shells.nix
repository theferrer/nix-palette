{ pkgs }:
{
  nushell = {
    package = pkgs.nushell;
    provides = [ "shell" ];
  };
}
