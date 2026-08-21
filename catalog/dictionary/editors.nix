{ pkgs }:
{
  zed = {
    package = pkgs.zed-editor;
  };
  phpstorm = {
    package = pkgs.jetbrains.phpstorm;
  };
  clion = {
    package = pkgs.jetbrains.clion;
  };
  goland = {
    package = pkgs.jetbrains.goland;
  };
  datagrip = {
    package = pkgs.jetbrains.datagrip;
  };
  rider = {
    package = pkgs.jetbrains.rider;
  };
  rust-rover = {
    package = pkgs.jetbrains.rust-rover;
  };
  # Catalog key stays `antigravity` (wants.nix references it); upstream renamed
  # the derivation to antigravity-ide and the old name is now a warning alias.
  antigravity = {
    package = pkgs.antigravity-ide;
  };
}
