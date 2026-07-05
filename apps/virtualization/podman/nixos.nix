{
  config,
  lib,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "podman") {
  virtualisation.podman = {
    enable = true;

    dockerCompat = lib.mkDefault (!(canvasLib.isActive config "docker"));
    defaultNetwork.settings.dns_enabled = lib.mkDefault true;
  };
  virtualisation.oci-containers.backend = lib.mkDefault "podman";
}
