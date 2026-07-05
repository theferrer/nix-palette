{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:
let
  conf = if osConfig != null then osConfig else config;
  monitors = conf.canvas.hardware.monitors;
  hasMonitors = monitors != [ ];
  firstName = if hasMonitors then (builtins.head monitors).name else null;

  mkMonitorString =
    m:
    let
      modeStr =
        if m.resolution != null && m.refreshRate != null then
          "${m.resolution}@${toString m.refreshRate}"
        else if m.resolution != null then
          m.resolution
        else
          "preferred";
      position = if m.position != null then m.position else "auto";
      scale = if m.scale != null then toString m.scale else "1";

      hdrParams = if (m.hdr or false) then ",bitdepth,10,cm,srgb" else "";
    in
    "${m.name},${modeStr},${position},${scale}${hdrParams}";
in
{
  wayland.windowManager.hyprland.settings = {

    monitor = (map mkMonitorString monitors) ++ [ ",preferred,auto,1" ];

    exec-once = [
      ''
        ${pkgs.writeShellScript "monitor-handler" ''
          #!/usr/bin/env bash

          fix_workspaces() {
            for i in {1..10}; do
              hyprctl dispatch moveworkspacetomonitor "$i" "$(hyprctl monitors -j | jq -r '.[0].name')"
            done
          }

          while true; do
            hyprctl monitors -j | jq -r '.[].name' > /tmp/current_monitors
            sleep 2
            hyprctl monitors -j | jq -r '.[].name' > /tmp/new_monitors

            if ! diff -q /tmp/current_monitors /tmp/new_monitors > /dev/null; then
              echo "Monitor configuration changed, fixing workspaces..."
              fix_workspaces
            fi
          done
        ''}
      ''
    ];

    bind = lib.optionals hasMonitors [
      "SUPER CTRL, R, exec, hyprctl dispatch moveworkspacetomonitor 1 ${firstName} && hyprctl dispatch moveworkspacetomonitor 2 ${firstName} && hyprctl dispatch moveworkspacetomonitor 3 ${firstName}"
    ];
  };
}
