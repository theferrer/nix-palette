{
  wayland.windowManager.hyprland.settings.decoration = {
    rounding = 10;

    active_opacity = 1.0;
    inactive_opacity = 0.95;
    fullscreen_opacity = 1.0;

    shadow = {
      enabled = true;
      range = 20;
      render_power = 2;
      color = "rgba(0f0f1bee)";
      color_inactive = "rgba(0f0f1b99)";
      offset = "0 8";
      scale = 0.97;
    };

    dim_inactive = true;
    dim_strength = 0.1;
    dim_special = 0.2;
    dim_around = 0.4;

    blur = {
      enabled = true;
      passes = 3;
      size = 10;

      brightness = 1.0;
      contrast = 1.0;
      noise = 0.01;
      ignore_opacity = false;
      vibrancy = 0.2;
      vibrancy_darkness = 0.2;
      special = true;
      popups = true;
      popups_ignorealpha = 0.2;

      new_optimizations = true;
      xray = false;
    };
  };
}
