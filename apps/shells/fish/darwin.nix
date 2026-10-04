{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
let
  user = config.canvas.machine.primaryUser;
in
lib.mkIf (canvasLib.isActive config "fish") {
  # Registers fish in /etc/shells and sources nix-darwin's environment from
  # it. nix-darwin only applies `shell` to users listed in users.knownUsers,
  # which the host has to opt into (it needs the account's uid).
  programs.fish.enable = true;

  users.users = lib.optionalAttrs (user != null) {
    ${user}.shell = pkgs.fish;
  };
}
