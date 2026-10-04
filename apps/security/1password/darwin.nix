{
  config,
  lib,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "1password") {
  # The browser extensions and the SSH agent only talk to a copy that lives
  # in /Applications, so on macOS it comes from Homebrew, not the store.
  # Takes effect on hosts that enable nix-darwin's homebrew module.
  homebrew.casks = [ "1password" ];
}
