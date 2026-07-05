{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
let
  hyprlandUwsmSession =
    pkgs.runCommand "hyprland-uwsm-session"
      {
        passthru.providedSessions = [ "hyprland-uwsm" ];
      }
      ''
        mkdir -p $out/share/wayland-sessions
        cp ${pkgs.hyprland}/share/wayland-sessions/hyprland-uwsm.desktop \
          $out/share/wayland-sessions/hyprland-uwsm.desktop
      '';
in
lib.mkIf (canvasLib.isActive config "hyprland") {
  programs.hyprland.enable = lib.mkDefault true;
  programs.uwsm.enable = true;
  services.displayManager.sessionPackages = [ hyprlandUwsmSession ];
}
