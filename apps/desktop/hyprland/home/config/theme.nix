{ config, ... }:
{
  wayland.windowManager.hyprland.settings.source = [
    "${config.xdg.configHome}/theme/current/hyprland.conf"
  ];
}
