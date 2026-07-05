{ pkgs }:
{
  package = pkgs.kitty;
  provides = [ "terminal" ];
  homeModule = ./home;
}
