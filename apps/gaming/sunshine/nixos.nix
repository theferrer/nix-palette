{
  config,
  lib,
  pkgs,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "sunshine") {
  services.sunshine = {
    enable = true;
    package = lib.mkDefault (pkgs.sunshine.override { cudaSupport = false; });
    openFirewall = lib.mkDefault true;
    capSysAdmin = lib.mkDefault true;
  };
}
