{ pkgs }:
{
  qemu = {
    package = pkgs.qemu;
  };
  distrobox = {
    package = pkgs.distrobox;
  };
  looking-glass = {
    package = pkgs.looking-glass-client;
  };
  uv = {
    package = pkgs.uv;
  };
  gopls = {
    package = pkgs.gopls;
  };
  ledger-live-desktop = {
    package = pkgs.ledger-live-desktop;
  };
  radeontop = {
    package = pkgs.radeontop;
  };

  git-lfs = {
    package = pkgs.git-lfs;
  };
  delta = {
    package = pkgs.delta;
  };
  qbittorrent = {
    package = pkgs.qbittorrent;
  };
  gum = {
    package = pkgs.gum;
  };
  gping = {
    package = pkgs.gping;
  };
  hexyl = {
    package = pkgs.hexyl;
  };
  jless = {
    package = pkgs.jless;
  };
  viu = {
    package = pkgs.viu;
  };
  chafa = {
    package = pkgs.chafa;
  };
  doggo = {
    package = pkgs.doggo;
  };
  taskwarrior = {
    package = pkgs.taskwarrior3;
  };
  khal = {
    package = pkgs.khal;
  };
  nh = {
    package = pkgs.nh;
  };
  gotools = {
    package = pkgs.gotools;
  };
  gh-dash = {
    package = pkgs.gh-dash;
  };

  "1password-cli" = {
    package = pkgs._1password-cli;
  };
  godot = {
    package = pkgs.godot;
  };
  composer = {
    package = pkgs.phpPackages.composer;
  };
  phpactor = {
    package = pkgs.phpactor;
  };
  qmk = {
    package = pkgs.qmk;
  };
  dfu-util = {
    package = pkgs.dfu-util;
  };
}
