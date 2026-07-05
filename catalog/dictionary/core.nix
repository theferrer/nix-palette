{ pkgs }:
{

  alacritty = {
    package = pkgs.alacritty;
    provides = [ "terminal" ];
  };
  foot = {
    package = pkgs.foot;
    provides = [ "terminal" ];
  };
  wezterm = {
    package = pkgs.wezterm;
    provides = [ "terminal" ];
  };

  google-chrome = {
    package = pkgs.google-chrome;
    provides = [ "browser" ];
  };
  brave = {
    package = pkgs.brave;
    provides = [ "browser" ];
  };
  chromium = {
    package = pkgs.chromium;
    provides = [ "browser" ];
  };
  vivaldi = {
    package = pkgs.vivaldi;
    provides = [ "browser" ];
  };

  rofi = {
    package = pkgs.rofi;
    provides = [ "launcher" ];
  };
  wofi = {
    package = pkgs.wofi;
    provides = [ "launcher" ];
  };

  mako = {
    package = pkgs.mako;
    provides = [ "notifications" ];
  };

  waybar = {
    package = pkgs.waybar;
    provides = [ "bar" ];
  };

  bash = {
    package = pkgs.bash;
    provides = [ "shell" ];
  };
  zsh = {
    package = pkgs.zsh;
    provides = [ "shell" ];
  };

  thunar = {
    package = pkgs.xfce.thunar;
    provides = [ "file-manager" ];
  };

  imv = {
    package = pkgs.imv;
    provides = [ "image-viewer" ];
  };

  hyprshot = {
    package = pkgs.hyprshot;
    provides = [ "screenshot" ];
  };
  awww = {
    package = pkgs.awww;
    provides = [ "wallpaper" ];
  };
  hyprlock = {
    package = pkgs.hyprlock;
    provides = [ "screen-locker" ];
  };

}
