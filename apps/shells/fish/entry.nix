{ pkgs }:
{
  package = pkgs.fish;
  provides = [ "shell" ];
  homeModule = ./home;
}
