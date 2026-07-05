{ pkgs }:
{
  package = pkgs.syncthing;
  homeModule = ./home;
  secrets = {
    "syncthing/cert" = {
      description = "device certificate PEM; paired with syncthing/key";
    };
    "syncthing/key" = {
      description = "device key PEM; without it the device generates a fresh identity";
    };
  };
}
