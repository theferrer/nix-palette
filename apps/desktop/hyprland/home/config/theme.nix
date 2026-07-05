{ config, ... }:
{
  # Border colours are written here by DankMaterialShell's matugen run,
  # regenerated from the wallpaper on every theme change.
  wayland.windowManager.hyprland.settings.source = [
    "${config.xdg.configHome}/hypr/dms/colors.conf"
  ];
}
