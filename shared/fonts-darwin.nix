{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
lib.mkIf (canvasLib.isGraphical config) {
  # macOS renders with its own stack, so there is no fontconfig to tune; it
  # only needs the files. sf-pro is skipped: it is Apple's to begin with.
  fonts.packages = builtins.filter (
    p: lib.meta.availableOn pkgs.stdenv.hostPlatform p && lib.getName p != "sf-pro"
  ) (import ./font-packages.nix pkgs);
}
