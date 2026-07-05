{
  wayland.windowManager.hyprland.settings.group = {
    insert_after_current = true;

    focus_removed_window = true;

    # Group border colours come from the matugen-generated
    # ~/.config/hypr/dms/colors.conf sourced in theme.nix.

    groupbar = {
      gradients = false;
      font_size = 12;

      render_titles = false;
      scrolling = true;
    };
  };
}
