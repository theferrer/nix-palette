{ pkgs }:
{
  package = pkgs.neovim;
  provides = [ "editor" ];
}
