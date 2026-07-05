{
  config,
  lib,
  canvasLib,
  ...
}:
let
  user = config.canvas.machine.primaryUser;
in
lib.mkIf (canvasLib.isActive config "virt-manager") {
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = lib.mkDefault true;

  users.users = lib.optionalAttrs (user != null) {
    ${user}.extraGroups = [ "libvirtd" ];
  };
}
