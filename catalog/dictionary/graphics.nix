{ pkgs }:
{
  # Unfree (Igara Studio's EULA), so it is never in the binary cache: the EULA
  # lets you compile it for personal use but not redistribute the build. Skia
  # is cached, so only Aseprite itself compiles locally.
  aseprite = {
    package = pkgs.aseprite;
  };

  blender = {
    package = pkgs.blender;
  };

  # Agent bridges into the two apps above, both palette derivations (pkgs/).
  # aseprite-mcp runs Aseprite in batch mode per call; mcp-for-blender talks to
  # a live Blender, started with its add-on by the `blender-mcp` it also ships.
  aseprite-mcp.package = pkgs.aseprite-mcp;
  mcp-for-blender.package = pkgs.mcp-for-blender;

  # Sprite and texture post-processing: GIF previews, lossless PNG shrinking,
  # palette quantisation, background removal, and GPU texture / glTF packing
  # for the web.
  gifski.package = pkgs.gifski;
  oxipng.package = pkgs.oxipng;
  pngquant.package = pkgs.pngquant;
  rembg.package = pkgs.rembg;
  ktx-tools.package = pkgs.ktx-tools;
  meshoptimizer.package = pkgs.meshoptimizer;

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
