{ pkgs }:
{
  package = pkgs.git;
  homeModule = ./home;
}
