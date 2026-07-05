{ pkgs }:
{
  docker = {
    package = pkgs.docker;
  };
  podman-compose.package = pkgs.podman-compose;
  virt-viewer.package = pkgs.virt-viewer;
  looking-glass-client.package = pkgs.looking-glass-client;
}
