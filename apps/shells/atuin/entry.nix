{ pkgs }:
{
  package = pkgs.atuin;
  homeModule = ./home;
  secrets."atuin/key" = {
    description = "sync encryption key; without it this machine starts a fresh local identity";
  };
}
