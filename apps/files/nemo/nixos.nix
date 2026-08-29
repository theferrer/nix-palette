{
  config,
  lib,
  pkgs,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "nemo") {
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Space-to-preview is not built into Nemo: it dispatches over D-Bus to
  # org.Nemo.Previewer, and with nothing owning that name the key just does
  # nothing. nemo-preview ships the service file that makes it resolve, so it
  # has to be installed alongside rather than pulled in as a dependency.
  # ffmpegthumbnailer is here for the same reason -- Nemo reads thumbnailers
  # out of the environment's share/thumbnailers, so video tiles stay blank
  # until something provides one.
  environment.systemPackages = with pkgs; [
    nemo-preview
    ffmpegthumbnailer
  ];
}
