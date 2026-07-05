{
  wayland.windowManager.hyprland.settings = {

    windowrule = [
      "float on, match:class ^(bitwarden)$"
      "float on, match:class ^(rofi)$"
      "float on, match:class ^(pwvucontrol)$"
      "float on, match:class ^(nm-connection-editor)$"
      "float on, match:class ^(blueman-manager)$"

      "float on, match:class ^(hyprpicker)$"
      "stay_focused on, match:class ^(hyprpicker)$"
      "border_size 0, match:class ^(hyprpicker)$"

      "no_anim on, match:class ^(hyprshot)$"
      "no_blur on, match:class ^(hyprshot)$"
      "border_size 0, match:class ^(hyprshot)$"

      "float on, match:class ^(quickshell)$"
      "pin on, match:class ^(quickshell)$"
      "stay_focused on, match:class ^(quickshell)$"
      "no_blur on, match:class ^(quickshell)$"

      "float on, match:class ^(Network)$"
      "float on, match:class ^(xdg-desktop-portal)$"
      "float on, match:class ^(xdg-desktop-portal-gnome)$"
      "float on, match:class ^(transmission-gtk)$"
      "size 800 600, match:class ^(Bitwarden)$"

      "float on, match:class ^(1Password)$"
      "min_size 600 400, match:class ^(1Password)$"
      "center on, match:class ^(1Password)$"

      "pin on, match:title ^(HearthstoneOverlay)$"
      "no_focus on, match:title ^(HearthstoneOverlay)$"
      "no_initial_focus on, match:title ^(HearthstoneOverlay)$"
      "no_blur on, match:title ^(HearthstoneOverlay)$"
      "no_shadow on, match:title ^(HearthstoneOverlay)$"
      "opacity 0.3 0.3, match:title ^(HearthstoneOverlay)$"

      "float on, match:title ^(Picture-in-Picture)$"
      "float on, match:class ^(Viewnior)$"
      "float on, match:class ^(download)$"

      "workspace 6, match:title ^(.*(Disc|WebC)ord.*)$"

      "workspace special silent, match:title ^(Firefox — Sharing Indicator)$"
      "workspace special silent, match:title ^(.*is sharing (your screen|a window)\\.)$"

      "border_size 0, match:float true"
    ];
  };
}
