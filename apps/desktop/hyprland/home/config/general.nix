{
  wayland.windowManager.hyprland.settings.general = {
    layout = "dwindle";

    gaps_in = 8;
    gaps_out = 8;
    gaps_workspaces = 0;
    border_size = 2;

    # col.active_border / col.inactive_border are set by the matugen-generated
    # ~/.config/hypr/dms/colors.conf sourced in theme.nix.

    allow_tearing = true;
  };
}
