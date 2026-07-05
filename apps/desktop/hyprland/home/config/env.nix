{
  config,
  lib,
  osConfig ? null,
  ...
}:
let
  conf = if osConfig != null then osConfig else config;
  hw = conf.canvas.hardware;
  inherit (hw) gpus;

  primaryGpu = lib.findFirst (g: g.primary) (if gpus == [ ] then null else lib.head gpus) gpus;
  primaryVendor = if primaryGpu == null then null else primaryGpu.vendor;
  hasNvidia = lib.any (g: g.vendor == "nvidia") gpus;

  nvidiaForDisplay = primaryVendor == "nvidia";
  hybridNvidiaOffload = hasNvidia && hw.gpuStrategy == "offload";
  hasSecondaryGpu = builtins.length gpus > 1;

  drmDevicesIntegrated =
    if hybridNvidiaOffload then "/dev/dri/card0:/dev/dri/card1" else "/dev/dri/card0";
  drmDevicesNvidiaPrimary = if hasSecondaryGpu then "/dev/dri/card1" else "/dev/dri/card0";
in
{
  wayland.windowManager.hyprland.settings = {
    env =

      lib.optionals nvidiaForDisplay [
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "GBM_BACKEND,nvidia-drm"
        "NVD_BACKEND,direct"
        "VDPAU_DRIVER,nvidia"

        "AQ_DRM_DEVICES,${drmDevicesNvidiaPrimary}"

        "PROTON_ENABLE_NGX_UPDATER,1"
        "__VK_LAYER_NV_optimus,NVIDIA_only"
      ]

      ++ lib.optionals (primaryVendor == "intel" || primaryVendor == "amd") [
        "AQ_DRM_DEVICES,${drmDevicesIntegrated}"
      ];

    debug.disable_logs = false;
  };
}
