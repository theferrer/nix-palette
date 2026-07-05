{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
let
  inherit (config.canvas) resolved;
  onHyprland = (resolved.capabilityMap.desktop or null) == "hyprland";
in
lib.mkIf (canvasLib.isGraphical config) {
  xdg.portal = lib.mkMerge [
    {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = [ "gtk" ];
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    }
    (lib.mkIf onHyprland {
      config.hyprland.default = [
        "gtk"
        "hyprland"
      ];
    })
  ];
}
