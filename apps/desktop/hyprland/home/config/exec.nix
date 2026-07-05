{
  config,
  lib,
  pkgs,
  ...
}:
let
  pointer = config.home.pointerCursor or null;
in
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [

      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
    ]
    ++ lib.optionals (pointer != null) [
      "hyprctl setcursor ${pointer.name} ${toString pointer.size}"
    ]
    ++ [
      "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
      "nm-applet --indicator"
    ];
  };
}
