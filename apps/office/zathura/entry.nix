{ pkgs }:
{
  package = pkgs.zathura;
  provides = [ "pdf-viewer" ];
  homeModule = ./home;
}
