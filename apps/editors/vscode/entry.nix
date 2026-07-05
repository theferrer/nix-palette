{ pkgs }:
{
  package = pkgs.vscode;
  provides = [ "editor" ];
  homeModule = ./home;
}
