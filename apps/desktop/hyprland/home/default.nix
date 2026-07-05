{
  imports = [
    ./config
    ./power-aware.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    configType = "hyprlang";

    systemd.enable = false;
  };
}
