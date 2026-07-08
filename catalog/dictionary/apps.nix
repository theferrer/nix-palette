{ pkgs }:
{
  obsidian = {
    package = pkgs.obsidian;
  };
  discord = {
    package = pkgs.discord;
  };
  slack = {
    package = pkgs.slack;
  };
  telegram = {
    package = pkgs.telegram-desktop;
  };
  spotify = {
    package = pkgs.spotify;
  };
  vlc = {
    package = pkgs.vlc;
  };
  gimp = {
    package = pkgs.gimp;
  };
  inkscape = {
    package = pkgs.inkscape;
  };
  libreoffice = {
    package = pkgs.libreoffice;
  };
  thunderbird = {
    package = pkgs.thunderbird;
  };
  lutris = {
    package = pkgs.lutris;
  };
  mangohud = {
    package = pkgs.mangohud;
  };
  moonlight = {
    package = pkgs.moonlight-qt;
  };

  keepassxc.package = pkgs.keepassxc;
  foliate.package = pkgs.foliate;
  marktext.package = pkgs.marktext;
  apostrophe.package = pkgs.apostrophe;
  freetube.package = pkgs.freetube;
  gnome-boxes.package = pkgs.gnome-boxes;
  pika-backup.package = pkgs.pika-backup;
}
