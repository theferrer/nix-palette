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

  # Expose ONLY the uwsm-managed session to the greeter. The raw
  # hyprland.desktop (added unconditionally by programs.hyprland) does not
  # start graphical-session.target, so user services with
  # WantedBy=graphical-session.target (dms bar/launcher/wallpaper) never
  # activate when it is picked.
  services.displayManager.sessionPackages = lib.mkForce [ hyprlandUwsmSession ];
}
