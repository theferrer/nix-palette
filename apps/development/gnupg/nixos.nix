{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
lib.mkIf (canvasLib.isActive config "gnupg" && canvasLib.isGraphical config) {
  # The 3.x series, not gcr_4: the SystemPrompter service pinentry-gnome3 talks
  # to lives there -- gcr 4 replaced it with gcr-ssh-agent and ships no prompter
  # at all. Which attribute holds it depends on the consumer's nixpkgs, since
  # that is what this flake follows: `gcr_3` only appeared when nixpkgs turned
  # the unversioned `gcr` into a throw, so hosts pinned before that still have
  # to reach for `gcr` (also 3.x) and would fail to evaluate on `gcr_3` alone.
  services.dbus.packages = [ (pkgs.gcr_3 or pkgs.gcr) ];
}
