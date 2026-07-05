{ pkgs }:
{
  package = pkgs.gnupg;
  homeModule = ./home;
}
