{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
let
  conf = if osConfig != null then osConfig else config;
  isLaptop = conf.canvas.machine.formFactor == "laptop";

  hyprland-power-mode = pkgs.writeShellApplication {
    name = "hyprland-power-mode";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      hyprland
    ];
    text = ''
      POWER_STATE="battery"

      for ac in /sys/class/power_supply/AC*/online; do
        if [ -f "$ac" ]; then
          if [ "$(cat "$ac")" = "1" ]; then
            POWER_STATE="ac"
            break
          fi
        fi
      done

      if [ -f /sys/class/power_supply/ACAD/online ]; then
        if [ "$(cat /sys/class/power_supply/ACAD/online)" = "1" ]; then
          POWER_STATE="ac"
        fi
      fi

      echo "Power state: $POWER_STATE"

      HYPR_INSTANCE=$(find "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hypr" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | head -n 1)
      if [ -z "$HYPR_INSTANCE" ]; then
        echo "Hyprland not running, skipping"
        exit 0
      fi

      export HYPRLAND_INSTANCE_SIGNATURE="$HYPR_INSTANCE"

      if [ "$POWER_STATE" = "ac" ]; then
        echo "Switching to AC mode: Full effects"

        hyprctl keyword decoration:blur:enabled true
        hyprctl keyword decoration:blur:passes 3
        hyprctl keyword decoration:blur:size 10

        hyprctl keyword decoration:shadow:enabled true
        hyprctl keyword decoration:shadow:range 20

        hyprctl keyword decoration:dim_inactive true
        hyprctl keyword decoration:dim_strength 0.1

        hyprctl keyword animation "windowsIn, 1, 4, md2, popin 85%"
        hyprctl keyword animation "windowsOut, 1, 4, smoothOut, popin 85%"
        hyprctl keyword animation "windowsMove, 1, 4, softAcDecel, slide"
        hyprctl keyword animation "workspaces, 1, 4, overshot, slide"

      else
        echo "Switching to Battery mode: Optimized for power saving"

        hyprctl keyword decoration:blur:enabled false
        hyprctl keyword decoration:shadow:enabled false
        hyprctl keyword decoration:dim_inactive false

        hyprctl keyword animation "windowsIn, 1, 2, md2, popin 90%"
        hyprctl keyword animation "windowsOut, 1, 2, smoothOut, popin 90%"
        hyprctl keyword animation "windowsMove, 1, 2, softAcDecel, slide"
        hyprctl keyword animation "workspaces, 1, 2, overshot, slide"
      fi

      echo "Hyprland power mode updated successfully"
    '';
  };
in
lib.mkIf isLaptop {
  systemd.user.services.hyprland-power-monitor = {
    Unit = {
      Description = "Monitor AC/Battery state and adjust Hyprland settings";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${lib.getExe hyprland-power-mode}";
      RemainAfterExit = false;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.paths.hyprland-power-monitor = {
    Unit = {
      Description = "Watch for AC/Battery state changes";
      PartOf = [ "graphical-session.target" ];
    };

    Path = {
      PathChanged = [
        "/sys/class/power_supply/AC0/online"
        "/sys/class/power_supply/AC1/online"
        "/sys/class/power_supply/ACAD/online"
      ];
      Unit = "hyprland-power-monitor.service";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  wayland.windowManager.hyprland.settings.exec-once = [
    "${lib.getExe hyprland-power-mode}"
  ];
}
