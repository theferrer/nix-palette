{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
let
  themes = import ../themes;
  conf = if osConfig != null then osConfig else config;
  active = conf.canvas.resolved.software or { };
  styleName = conf.canvas.style.name or null;
  defaultTheme =
    if styleName != null && themes ? ${styleName} then styleName else lib.head (lib.attrNames themes);

  renderers = import ./renderers;

  currentDir = "${config.xdg.configHome}/theme/current";

  fragmentsFor =
    name: theme:
    lib.concatMapAttrs (
      app: r:
      lib.optionalAttrs (active ? ${app}) {
        "canvas-themes/${name}/${r.file}".text = r.render theme.colors;
      }
    ) renderers.fragments
    // lib.optionalAttrs (theme ? wallpaper) {
      "canvas-themes/${name}/wallpaper".source = theme.wallpaper;
    };

  themeSet = pkgs.writeShellApplication {
    name = "theme-set";
    text = ''
      themes_dir="''${XDG_DATA_HOME:-$HOME/.local/share}/canvas-themes"
      link_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/theme"

      if [ "$#" -ne 1 ] || [ ! -d "$themes_dir/''${1}" ]; then
        echo "usage: theme-set <name>" >&2
        echo "available themes:" >&2
        ls -1 "$themes_dir" >&2
        exit 1
      fi

      name="$1"
      mkdir -p "$link_dir"
      ln -sfn "$themes_dir/$name" "$link_dir/current"

      wp="$link_dir/current/wallpaper"
      if [ -e "$wp" ]; then
        if [ -n "''${WAYLAND_DISPLAY:-}" ] && command -v awww > /dev/null; then
          awww img "$wp" || true
        elif [ -n "''${WAYLAND_DISPLAY:-}" ] && command -v swww > /dev/null; then
          swww img "$wp" || true
        elif command -v feh > /dev/null; then
          feh --bg-fill "$wp" || true
        fi
      fi

      pkill -USR1 -x kitty 2> /dev/null || true
      if command -v hyprctl > /dev/null; then
        hyprctl reload > /dev/null 2>&1 || true
      fi
      if [ -e "$wp" ] && command -v dms > /dev/null; then
        dms ipc call wallpaper set "$wp" > /dev/null 2>&1 || true
      fi

      echo "theme: $name"
    '';
  };
in
{
  imports = [
    ./gui.nix
    ./apps.nix
  ];

  warnings =
    lib.optional (styleName != null && !(themes ? ${styleName}))
      "palette: canvas.style.name \"${styleName}\" is not a registered theme; falling back to \"${defaultTheme}\"";

  home.packages = [ themeSet ];

  xdg.dataFile = lib.mkMerge (lib.mapAttrsToList fragmentsFor themes);

  # kitty, hyprland and gtk colours are owned by DankMaterialShell's matugen
  # run (regenerated from the wallpaper), not by static fragments.

  home.activation.canvasThemeLink = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    link="${currentDir}"
    if [ ! -e "$link" ]; then
      run mkdir -p "$(dirname "$link")"
      run ln -sfn ${lib.escapeShellArg "${config.xdg.dataHome}/canvas-themes/${defaultTheme}"} "$link"
    fi
  '';
}
