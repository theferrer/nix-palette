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

  primaryVendor =
    let
      primaryGpu = lib.findFirst (g: g.primary) (if gpus == [ ] then null else lib.head gpus) gpus;
    in
    if primaryGpu == null then null else primaryGpu.vendor;

  nvidiaForDisplay = primaryVendor == "nvidia";
  multiGpu = builtins.length gpus > 1;

  # "PCI:12:0:0" (Xorg BusID, decimal) -> "/dev/dri/by-path/pci-0000:0c:00.0-card".
  # Stable across boots, unlike the /dev/dri/cardN minors (which depend on probe
  # order, simpledrm/efifb, timing) and vary per machine for the same GPU.
  busPath =
    busId:
    let
      p = lib.splitString ":" (lib.removePrefix "PCI:" busId);
      hex2 = n: lib.toLower (lib.fixedWidthString 2 "0" (lib.toHexString (lib.toInt n)));
    in
    "/dev/dri/by-path/pci-0000:${hex2 (lib.elemAt p 0)}:${hex2 (lib.elemAt p 1)}.${lib.elemAt p 2}-card";

  # Primary GPU first, then the rest. AQ_DRM_DEVICES only matters when there is
  # more than one GPU to order; a single-GPU host autodetects (robust to any minor).
  orderedGpus = (lib.filter (g: g.primary) gpus) ++ (lib.filter (g: !g.primary) gpus);
  drmDevices = lib.concatMapStringsSep ":" (g: busPath g.busId) orderedGpus;
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

        "PROTON_ENABLE_NGX_UPDATER,1"
        "__VK_LAYER_NV_optimus,NVIDIA_only"
      ]

      ++ lib.optionals multiGpu [
        "AQ_DRM_DEVICES,${drmDevices}"
      ];

    debug.disable_logs = false;
  };
}
