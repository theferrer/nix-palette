# The font set every graphical host gets, NixOS and darwin alike.
pkgs:
let
  palettePkgs = import ../pkgs pkgs;
in
builtins.attrValues {
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
}
++ [ pkgs.nerd-fonts.jetbrains-mono ]
