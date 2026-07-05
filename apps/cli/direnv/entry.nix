{ pkgs }:
{
  package = pkgs.direnv;
  homeModule = ./home;
}
