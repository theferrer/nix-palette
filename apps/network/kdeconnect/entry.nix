{ pkgs }:
{
  package = pkgs.kdePackages.kdeconnect-kde;
  homeModule = ./home;
}
