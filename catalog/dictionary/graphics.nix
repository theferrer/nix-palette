{ pkgs }:
{
  blender = {
    package = pkgs.blender;
  };

  krita = {
    package = pkgs.krita;
    provides = [ "image-viewer" ];
  };

  gthumb = {
    package = pkgs.gthumb;
    provides = [ "image-viewer" ];
  };

  peek = {
    package = pkgs.peek;
  };

  gpick = {
    package = pkgs.gpick;
  };

  "font-manager" = {
    package = pkgs.font-manager;
  };
  glmark2.package = pkgs.glmark2;
  mesa-demos.package = pkgs.mesa-demos;
  vulkan-tools.package = pkgs.vulkan-tools;
  libva-utils.package = pkgs.libva-utils;
  intel-gpu-tools.package = pkgs.intel-gpu-tools;
  v4l-utils.package = pkgs.v4l-utils;
  geoclue.package = pkgs.geoclue2;
}
