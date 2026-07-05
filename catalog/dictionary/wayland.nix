{ pkgs }:
{
  grim = {
    package = pkgs.grim;
    provides = [ "screenshot" ];
  };

  slurp = {
    package = pkgs.slurp;
  };

  hyprpicker = {
    package = pkgs.hyprpicker;
  };

  wl-clipboard = {
    package = pkgs.wl-clipboard;
  };

  cliphist = {
    package = pkgs.cliphist;
  };

  hypridle = {
    package = pkgs.hypridle;
  };

  hyprpaper = {
    package = pkgs.hyprpaper;
    provides = [ "wallpaper" ];
  };

  swaync = {
    package = pkgs.swaynotificationcenter;
    provides = [ "notifications" ];
  };

  swappy = {
    package = pkgs.swappy;
  };

  wl-gammactl = {
    package = pkgs.wl-gammactl;
  };

  swayidle = {
    package = pkgs.swayidle;
  };

  wlsunset = {
    package = pkgs.wlsunset;
  };

  gammastep = {
    package = pkgs.gammastep;
  };

  wlogout = {
    package = pkgs.wlogout;
  };

  network-manager-applet = {
    package = pkgs.networkmanagerapplet;
  };

  gnome-bluetooth = {
    package = pkgs.gnome-bluetooth;
  };

  grimblast = {
    package = pkgs.grimblast;
    provides = [ "screenshot" ];
  };

  wl-clip-persist = {
    package = pkgs.wl-clip-persist;
  };
  wl-ocr.package = pkgs.wl-ocr;
}
