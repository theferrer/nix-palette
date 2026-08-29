{ pkgs }:
{
  package = pkgs.nemo;
  provides = [ "file-manager" ];
  homeModule = ./home;
}
