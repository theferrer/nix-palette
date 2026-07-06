{
  pkgs,
  lib,
  config,
  ...
}:
{
  # The rnnoise noise-canceling filter-chain (shared/audio/default.nix) loads the
  # LADSPA plugin by name, so pipewire must find it on its LADSPA_PATH. pipewire
  # resolves that field relative to LADSPA_PATH even when given an absolute path,
  # so the package has to be added here rather than pointed at from the conf.
  services.pipewire.extraLadspaPackages = lib.mkIf config.services.pipewire.enable [
    pkgs.rnnoise-plugin
  ];
}
