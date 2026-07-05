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
  # The NixOS side registers fish as a login shell and generates vendor
  # completions for system packages; the home module configures the user's fish.
  programs.fish.enable = true;

  users.users = lib.optionalAttrs (user != null) {
    ${user}.shell = pkgs.fish;
  };
}
