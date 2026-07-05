{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
let
  palettePkgs = import ../pkgs pkgs;
in
lib.mkIf (canvasLib.isGraphical config) {
  fonts = {
    packages = builtins.attrValues {
      inherit (pkgs)
        corefonts
        source-sans
        source-serif
        dejavu_fonts
        inter
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        jetbrains-mono
        material-icons
        material-design-icons
        material-symbols
        rubik
        geist-font
        ;
      inherit (pkgs.nerd-fonts) symbols-only space-mono;
      inherit (palettePkgs) sf-pro quickshell-fonts;
    };

    fontconfig = {
      enable = true;
      hinting.enable = true;
      antialias = true;
    };
  };
}
