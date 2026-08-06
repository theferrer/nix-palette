{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
let
  gpus = config.canvas.hardware.gpus or [ ];
  multiGpu = builtins.length gpus > 1;

  # Xorg BusID "PCI:12:0:0" (decimal) -> PCI slot "0000:0c:00.0".
  busPci =
    busId:
    let
      p = lib.splitString ":" (lib.removePrefix "PCI:" busId);
      hex2 = n: lib.toLower (lib.fixedWidthString 2 "0" (lib.toHexString (lib.toInt n)));
    in
    "0000:${hex2 (lib.elemAt p 0)}:${hex2 (lib.elemAt p 1)}.${lib.elemAt p 2}";

  # ':'-free alias under /dev/dri/by-canvas/, kept in sync with env.nix. Needed
  # because aquamarine splits AQ_DRM_DEVICES on ':' (so by-path names with PCI
  # slots break it) while /dev/dri/cardN minors are not stable across boots.
  aliasName = busId: lib.replaceStrings [ ":" "." ] [ "_" "_" ] (busPci busId);

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

  # Stable, ':'-free DRM aliases for AQ_DRM_DEVICES (see aliasName above). Match
  # the card node by its PCI slot (KERNELS), which is stable, and symlink it to
  # a fixed name under /dev/dri/by-canvas/. Only multi-GPU hosts need ordering;
  # single-GPU hosts let aquamarine autodetect.
  services.udev.extraRules = lib.mkIf multiGpu (
    lib.concatMapStringsSep "\n" (
      g:
      ''SUBSYSTEM=="drm", KERNEL=="card[0-9]*", KERNELS=="${busPci g.busId}", SYMLINK+="dri/by-canvas/${aliasName g.busId}"''
    ) gpus
  );

  # Expose ONLY the uwsm-managed session to the greeter. The raw
  # hyprland.desktop (added unconditionally by programs.hyprland) does not
  # start graphical-session.target, so user services with
  # WantedBy=graphical-session.target (dms bar/launcher/wallpaper) never
  # activate when it is picked.
  services.displayManager.sessionPackages = lib.mkForce [ hyprlandUwsmSession ];
}
