{
  config,
  lib,
  canvasLib,
  ...
}:
let
  user = config.canvas.machine.primaryUser;
in
lib.mkIf (canvasLib.isActive config "wireshark") {
  programs.wireshark.enable = true;
  users.users = lib.optionalAttrs (user != null) {
    ${user}.extraGroups = [ "wireshark" ];
  };
}
