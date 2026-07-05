{ pkgs }:
{
  package = pkgs.ghostty;
  provides = [ "terminal" ];
  homeModule = ./home;
}
