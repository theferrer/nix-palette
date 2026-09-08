{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
lib.mkIf (canvasLib.isActive config "gnupg" && canvasLib.isGraphical config) {
  # gcr_3, not gcr_4: nixpkgs dropped the unversioned `gcr` alias, and the
  # SystemPrompter service pinentry-gnome3 talks to lives in the 3.x series --
  # gcr 4 replaced it with gcr-ssh-agent and ships no prompter at all.
  services.dbus.packages = [ pkgs.gcr_3 ];
}
