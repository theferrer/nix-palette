{
  pkgs,
  wallpaper,
  name,
}:
# Boot-time surfaces (VT console, plymouth) cannot run matugen live, so we run
# it once at build time over the wallpaper and bake the base16 palette in. This
# is import-from-derivation: the matugen run happens during evaluation.
let
  drv =
    pkgs.runCommand "matugen-boot-${name}"
      {
        nativeBuildInputs = [
          pkgs.matugen
          pkgs.jq
        ];
      }
      ''
        export HOME="$TMPDIR"
        matugen image ${wallpaper} --json hex --prefer saturation --mode dark > raw.json
        mkdir -p "$out"
        jq '{
          base00: .base16.base00.dark.color,
          base01: .base16.base01.dark.color,
          base02: .base16.base02.dark.color,
          base03: .base16.base03.dark.color,
          base04: .base16.base04.dark.color,
          base05: .base16.base05.dark.color,
          base06: .base16.base06.dark.color,
          base07: .base16.base07.dark.color,
          base08: .base16.base08.dark.color,
          base09: .base16.base09.dark.color,
          base0A: .base16.base0a.dark.color,
          base0B: .base16.base0b.dark.color,
          base0C: .base16.base0c.dark.color,
          base0D: .base16.base0d.dark.color,
          base0E: .base16.base0e.dark.color,
          base0F: .base16.base0f.dark.color
        }' raw.json > "$out/colors.json"
      '';
in
builtins.fromJSON (builtins.readFile "${drv}/colors.json")
