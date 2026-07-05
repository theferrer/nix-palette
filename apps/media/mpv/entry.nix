{ pkgs }:
{
  package = pkgs.mpv;
  provides = [
    "video-player"
    "audio-player"
  ];
  homeModule = ./home;
}
