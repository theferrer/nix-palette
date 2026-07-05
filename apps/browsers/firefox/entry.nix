{ pkgs }:
{
  package = pkgs.firefox;
  provides = [ "browser" ];
  homeModule = ./home;
}
