{ pkgs }:
{
  onlyoffice = {
    package = pkgs.onlyoffice-desktopeditors;
  };
  wpsoffice = {
    package = pkgs.wpsoffice;
  };
  logseq = {
    package = pkgs.logseq;
  };
  joplin = {
    package = pkgs.joplin-desktop;
  };
  xournalpp = {
    package = pkgs.xournalpp;
  };
  calibre = {
    package = pkgs.calibre;
  };
  evince = {
    package = pkgs.evince;
    provides = [ "pdf-viewer" ];
  };
  okular = {
    package = pkgs.kdePackages.okular;
    provides = [ "pdf-viewer" ];
  };
  sioyek = {
    package = pkgs.sioyek;
    provides = [ "pdf-viewer" ];
  };
  super-productivity = {
    package = pkgs.super-productivity;
  };
  qalculate-gtk = {
    package = pkgs.qalculate-gtk;
  };
  gnome-calculator = {
    package = pkgs.gnome-calculator;
  };
  speedcrunch = {
    package = pkgs.speedcrunch;
  };
  zotero = {
    package = pkgs.zotero;
  };
  rstudio = {
    package = pkgs.rstudio;
  };
  jupyter = {
    package = pkgs.jupyter;
  };
  texmaker = {
    package = pkgs.texmaker;
  };
  drawio = {
    package = pkgs.drawio;
  };
  plantuml = {
    package = pkgs.plantuml;
  };
}
