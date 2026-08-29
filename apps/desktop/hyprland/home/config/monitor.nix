{
  config,
  lib,
  osConfig ? null,
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

    # No monitor-watching loop here. There used to be a shell script polling
    # `hyprctl monitors` every 2s into fixed /tmp paths and firing ten
    # moveworkspacetomonitor dispatches on any change -- which meant it also
    # fired during lid open and resume, racing the compositor while it was
    # still bringing the output back. Hyprland reapplies the monitor= rules on
    # reconnect by itself, and the SUPER CTRL R bind below re-herds workspaces
    # on demand when a hotplug leaves them somewhere unhelpful.

    bind = lib.optionals hasMonitors [
      "SUPER CTRL, R, exec, hyprctl dispatch moveworkspacetomonitor 1 ${firstName} && hyprctl dispatch moveworkspacetomonitor 2 ${firstName} && hyprctl dispatch moveworkspacetomonitor 3 ${firstName}"
    ];
  };
}
