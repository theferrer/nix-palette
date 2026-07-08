{ pkgs }:
{
  cosmic-files = {
    package = pkgs.cosmic-files;
    provides = [ "file-manager" ];
  };

  dolphin = {
    package = pkgs.kdePackages.dolphin;
    provides = [ "file-manager" ];
  };

  nemo-preview = {
    package = pkgs.nemo-preview;
  };

  nautilus = {
    package = pkgs.nautilus;
    provides = [ "file-manager" ];
  };

  pcmanfm = {
    package = pkgs.pcmanfm;
    provides = [ "file-manager" ];
  };

  krusader = {
    package = pkgs.krusader;
    provides = [ "file-manager" ];
  };

  file-roller = {
    package = pkgs.file-roller;
  };
  ffmpegthumbnailer.package = pkgs.ffmpegthumbnailer;
  czkawka.package = pkgs.czkawka;
}
