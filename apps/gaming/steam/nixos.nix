{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
lib.mkIf (canvasLib.isActive config "steam") {
  programs.steam = {
    enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin.steamcompattool
      pkgs.proton-ge-bin
    ];

    gamescopeSession.enable = false;
  };
}
