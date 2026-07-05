{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
let
  themes = import ../theme/themes;
  styleName = config.canvas.style.name or null;
  themeName =
    if styleName != null && themes ? ${styleName} then styleName else lib.head (lib.attrNames themes);
  colors = import ../theme/boot-palette.nix {
    inherit pkgs;
    inherit (themes.${themeName}) wallpaper;
    name = themeName;
  };

  hex = c: builtins.substring 1 6 colors.${c};
in
lib.mkIf (canvasLib.isGraphical config) {
  # The VT palette: 0-7 normal, 8-15 bright. tuigreet and anything else drawn
  # on the console inherit these colors.
  console = {
    earlySetup = true;
    font = lib.mkDefault "ter-v16n";
    packages = [ pkgs.terminus_font ];
    colors = map hex [
      "base00"
      "base08"
      "base0B"
      "base0A"
      "base0D"
      "base0E"
      "base0C"
      "base05"
      "base03"
      "base08"
      "base0B"
      "base09"
      "base0D"
      "base0E"
      "base0C"
      "base06"
    ];
  };
}
