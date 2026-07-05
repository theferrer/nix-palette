{
  config,
  lib,
  osConfig ? null,
  ...
}:
let
  conf = if osConfig != null then osConfig else config;
  secret = name: conf.canvas.secrets.${name} or null;
in
{
  services.syncthing = {
    enable = true;
    cert = lib.mkIf (secret "syncthing/cert" != null) (secret "syncthing/cert");
    key = lib.mkIf (secret "syncthing/key" != null) (secret "syncthing/key");
  };
}
