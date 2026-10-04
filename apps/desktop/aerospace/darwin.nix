{
  config,
  lib,
  canvasLib,
  ...
}:
let
  themes = import ../../../theme/themes;
  styleName = config.canvas.style.name or null;
  theme = themes.${styleName} or themes.${lib.head (lib.attrNames themes)};
  argb = hex: "0xff${lib.removePrefix "#" hex}";
in
lib.mkIf (canvasLib.isActive config "aerospace") {
  # Hyprland's 2px active border, which AeroSpace does not draw itself.
  services.jankyborders = {
    enable = true;
    active_color = argb theme.colors.accent;
    inactive_color = argb theme.colors.base02;
    width = 4.0;
    hidpi = true;
  };

  system.defaults = {
    # AeroSpace fakes workspaces by moving windows off-screen; macOS Spaces
    # fight it unless each display stops having its own set.
    spaces.spans-displays = true;
    dock = {
      mru-spaces = false;
      # Mission Control otherwise shows AeroSpace's parked windows as tiny
      # slivers; grouping by app keeps it usable.
      expose-group-apps = true;
    };
    # ctrl-cmd drag moves a window from anywhere in it, as SUPER-drag did.
    NSGlobalDomain.NSWindowShouldDragOnGesture = true;
  };
}
