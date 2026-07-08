{ pkgs }:
{
  amberol = {
    package = pkgs.amberol;
    provides = [ "audio-player" ];
  };
  blanket = {
    package = pkgs.blanket;
    provides = [ "audio-player" ];
  };
  celluloid = {
    package = pkgs.celluloid;
    provides = [ "video-player" ];
  };
  hypnotix = {
    package = pkgs.hypnotix;
    provides = [ "video-player" ];
  };
  loupe = {
    package = pkgs.loupe;
    provides = [ "image-viewer" ];
  };
  viewnior = {
    package = pkgs.viewnior;
    provides = [ "image-viewer" ];
  };
  pavucontrol = {
    package = pkgs.pavucontrol;
  };
  pwvucontrol = {
    package = pkgs.pwvucontrol;
  };
  pulsemixer = {
    package = pkgs.pulsemixer;
  };
  termusic = {
    package = pkgs.termusic;
    provides = [ "audio-player" ];
  };
  easyeffects = {
    package = pkgs.easyeffects;
  };
  audacity = {
    package = pkgs.audacity;
  };
  davinci-resolve = {
    package = pkgs.davinci-resolve;
  };
  lmms = {
    package = pkgs.lmms;
  };
  bitwig-studio = {
    package = pkgs.bitwig-studio;
  };
  kodi = {
    package = pkgs.kodi;
    provides = [ "video-player" ];
  };
  darktable = {
    package = pkgs.darktable;
  };
  ffmpeg = {
    package = pkgs.ffmpeg;
  };
  imagemagick = {
    package = pkgs.imagemagick;
  };
  handbrake = {
    package = pkgs.handbrake;
  };
  cmus = {
    package = pkgs.cmus;
    provides = [ "audio-player" ];
  };
  jellyfin = {
    package = pkgs.jellyfin;
  };
  spicetify = {
    package = pkgs.spicetify-cli;
  };
  gpodder = {
    package = pkgs.gpodder;
    provides = [ "audio-player" ];
  };
  yt-dlp = {
    package = pkgs.yt-dlp;
  };
  pipe-viewer = {
    package = pkgs.pipe-viewer;
  };
  davinci-resolve-studio.package = pkgs.davinci-resolve-studio;
  ffmpeg-full.package = pkgs.ffmpeg-full;
  helvum.package = pkgs.helvum;
  qpwgraph.package = pkgs.qpwgraph;
}
