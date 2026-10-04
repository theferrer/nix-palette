{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
lib.mkIf (canvasLib.isGraphical config) {
  fonts = {
    packages = import ./font-packages.nix pkgs;

    fontconfig = {
      enable = true;
      hinting.enable = true;
      antialias = true;
    };
  };
}
