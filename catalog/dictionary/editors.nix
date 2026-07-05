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
  antigravity = {
    package = pkgs.antigravity;
  };
}
