{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
let
  sessionData = config.services.displayManager.sessionData.desktops;
  sessionPath = lib.concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];
in
lib.mkIf (canvasLib.isActive config "greetd") {
  services.greetd = {
    enable = lib.mkDefault true;
    useTextGreeter = lib.mkDefault true;
    settings.default_session.command = lib.mkDefault "${lib.getExe pkgs.tuigreet} --time --remember --remember-user-session --asterisks --sessions '${sessionPath}'";
  };
}
