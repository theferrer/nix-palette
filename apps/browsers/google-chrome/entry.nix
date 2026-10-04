{ pkgs }:
{
  # Chrome on Linux ships with Vulkan off, and without it Dawn filters every
  # real adapter out: navigator.gpu exists but requestAdapter() is null (only
  # --enable-unsafe-webgpu's SwiftShader is left). With Vulkan on, every GPU
  # shows up; on a hybrid laptop default to the integrated one the compositor
  # already runs on and leave the discrete card to pages that ask for
  # high-performance. A single-GPU host gets that GPU either way.
  #
  # Chrome keeps only the last --enable-features, and the nixpkgs wrapper puts
  # its Wayland one before these, so it has to be repeated here.
  #
  # macOS has Metal under Dawn and no wrapper to pass flags through.
  package =
    if pkgs.stdenv.hostPlatform.isDarwin then
      pkgs.google-chrome
    else
      pkgs.google-chrome.override {
        commandLineArgs = builtins.concatStringsSep " " [
          "--enable-features=Vulkan,WaylandWindowDecorations"
          "--use-webgpu-power-preference=default-low-power"
        ];
      };
  provides = [ "browser" ];
}
