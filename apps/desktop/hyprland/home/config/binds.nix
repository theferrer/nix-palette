{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
let
  inherit (lib.lists) optionals;
  inherit (builtins) toString genList concatLists;

  # brightnessctl with no -d takes whichever device it enumerates first. On a
  # hybrid-graphics laptop that is the phantom nvidia_0 node the proprietary
  # driver hangs off the dGPU: writing to it moves a counter and nothing else,
  # so the brightness keys look dead while the panel's real device sits
  # untouched. NVreg_RegistryDwords=EnableBrightnessControl=0 does not stop the
  # node from being created, so pick the right device rather than suppress the
  # wrong one. Panel backlights are type "raw"; acpi_video* is "firmware" and
  # is usually the one that does nothing, hence the two-pass preference.
  brightness = pkgs.writeShellApplication {
    name = "canvas-brightness";
    runtimeInputs = [ pkgs.brightnessctl ];
    text = ''
      pick() {
        for d in /sys/class/backlight/*; do
          [ -e "$d/type" ] || continue
          case "$(basename "$d")" in nvidia_*) continue ;; esac
          [ -n "$1" ] && [ "$(cat "$d/type")" != "$1" ] && continue
          basename "$d"
          return 0
        done
        return 1
      }

      dev=$(pick raw || pick "" || true)

      if [ -n "$dev" ]; then
        exec brightnessctl -d "$dev" set "$1" -q
      fi
      exec brightnessctl set "$1" -q
    '';
  };

  conf = if osConfig != null then osConfig else config;
  inherit (conf.canvas) resolved;
  appFor = cap: resolved.capabilityMap.${cap} or null;

  exeFor =
    cap:
    let
      app = appFor cap;
      package = if app == null then null else resolved.software.${app}.package or null;
    in
    if app == null then
      null
    else if package == null then
      app
    else
      lib.getExe package;

  terminal = exeFor "terminal";
  bar = appFor "bar";

  mod = "SUPER";
in
{
  wayland.windowManager.hyprland.settings = {
    bind = [

      "${mod}, B, exec, ${toString (exeFor "browser")}"
      "${mod}, E, exec, ${toString (exeFor "file-manager")}"
      "${mod}, C, exec, ${toString (exeFor "editor")}"
      "${mod}, Return, exec, ${toString terminal}"
      "${mod}, O, exec, obsidian"

      "${mod}, Q, killactive,"
      "${mod}, F, fullscreen,"
      "${mod}, Space, togglefloating,"
      "${mod}, P, pseudo,"
      "${mod}, S, layoutmsg, togglesplit"

      "${mod}, g, togglegroup"
      "${mod}, tab, changegroupactive"

      "${mod}, code:49, togglespecialworkspace"
      "${mod} SHIFT, code:49, movetoworkspace, special"

      ", Print, exec, hyprshot -m region --clipboard-only --freeze --silent"
      "${mod} SHIFT, S, exec, hyprshot -m region --freeze --silent"
      "${mod} SHIFT, W, exec, hyprshot -m window --silent"
      "${mod} SHIFT, M, exec, hyprshot -m output --silent"

      "${mod} SHIFT, P, exec, hyprpicker -a -f hex"

      "${mod}, G, exec, ${toString terminal} -e lazygit"
      "${mod} SHIFT, D, exec, ${toString terminal} -e lazydocker"
      "${mod} SHIFT, B, exec, ${toString terminal} -e btop"
      "${mod} SHIFT, E, exec, ${toString terminal} -e yazi"

      "${mod}, mouse_down, workspace, e+1"
      "${mod}, mouse_up, workspace, e-1"

      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
    ]
    ++ optionals (bar == "dms") [
      "${mod}, L, exec, dms ipc call lock lock"
      "${mod}, D, exec, dms ipc call spotlight toggle"
      "${mod}, escape, exec, dms ipc call session toggle"
      "${mod} SHIFT, R, exec, dms restart"
      "${mod}, Period, exec, dms ipc call emoji toggle"
      "${mod}, V, exec, dms ipc call clipboard toggle"
      "${mod}, N, exec, dms ipc call notifications toggle"
    ]
    ++ (concatLists (
      genList (
        x:
        let
          ws =
            let
              c = (x + 1) / 10;
            in
            toString (x + 1 - (c * 10));
        in
        [
          "${mod}, ${ws}, workspace, ${toString (x + 1)}"
          "${mod} SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        ]
      ) 10
    ));

    bindm = [
      "${mod}, mouse:272, movewindow"
      "${mod}, mouse:273, resizewindow"
    ];

    binde = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86MonBrightnessUp, exec, ${lib.getExe brightness} 5%+"
      ", XF86MonBrightnessDown, exec, ${lib.getExe brightness} 5%-"
    ];
  };
}
