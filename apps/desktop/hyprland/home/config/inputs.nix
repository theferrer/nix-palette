{
  config,
  lib,
  osConfig ? null,
  ...
}:
let
  conf = if osConfig != null then osConfig else config;
  hw = conf.canvas.hardware;
  isLaptop = conf.canvas.machine.formFactor == "laptop";
in
{
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = hw.keyboard.layout;
      kb_variant = lib.mkIf (hw.keyboard.variant != null) hw.keyboard.variant;

      kb_options = lib.concatStringsSep "," ([ "grp:alt_shift_toggle" ] ++ hw.keyboard.options);
      follow_mouse = 1;
      sensitivity = 0;

      touchpad = {
        tap-to-click = true;
        natural_scroll = false;
        disable_while_typing = false;
      };
    };

    gesture = lib.optionals isLaptop [
      "3, l, workspace, e-1"
      "3, r, workspace, e+1"
    ];

    cursor = {
      no_hardware_cursors = false;
    };
  };
}
