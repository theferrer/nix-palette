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

  hyprBin = lib.makeBinPath (builtins.attrValues { inherit (pkgs) hyprland coreutils systemd; });

  hyprctlBatch = keywords: ''
    export PATH=$PATH:${hyprBin}
    sig=$(ls -w1 "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hypr" 2>/dev/null | tail -1)
    [ -n "$sig" ] && export HYPRLAND_INSTANCE_SIGNATURE="$sig"
    hyprctl --batch '${keywords}'
  '';

  startscript = pkgs.writeShellScript "gamemode-start" ''
    ${lib.optionalString onHyprland (
      hyprctlBatch "keyword decoration:blur 0 ; keyword animations:enabled 0 ; keyword misc:vfr 0"
    )}
    ${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations activated'
  '';

  endscript = pkgs.writeShellScript "gamemode-end" ''
    ${lib.optionalString onHyprland (
      hyprctlBatch "keyword decoration:blur 1 ; keyword animations:enabled 1 ; keyword misc:vfr 1"
    )}
    ${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations deactivated'
  '';
in
lib.mkIf (canvasLib.isActive config "gamemode") {
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
      custom = {
        start = startscript.outPath;
        end = endscript.outPath;
      };
    };
  };
}
