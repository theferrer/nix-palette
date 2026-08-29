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

  # Xorg BusID "PCI:12:0:0" (decimal) -> PCI slot "0000:0c:00.0".
  busPci =
    busId:
    let
      p = lib.splitString ":" (lib.removePrefix "PCI:" busId);
      hex2 = n: lib.toLower (lib.fixedWidthString 2 "0" (lib.toHexString (lib.toInt n)));
    in
    "0000:${hex2 (lib.elemAt p 0)}:${hex2 (lib.elemAt p 1)}.${lib.elemAt p 2}";

  # aquamarine splits AQ_DRM_DEVICES on ':', but /dev/dri/by-path/pci-*-card node
  # names are full of ':' (PCI slots), so a by-path entry gets shredded and the
  # DRM backend finds no GPU (CBackend::create() fails, Hyprland aborts back to
  # the greeter). The bare /dev/dri/cardN minors have no ':' but are not stable
  # across boots (probe order, simpledrm/efifb, timing). So hyprland/nixos.nix
  # installs a udev rule giving each GPU a stable, ':'-free alias under
  # /dev/dri/by-canvas/; we point AQ_DRM_DEVICES at those. Keep the name in sync
  # with that rule (both derive it from busPci).
  aliasName = busId: lib.replaceStrings [ ":" "." ] [ "_" "_" ] (busPci busId);

  # Primary GPU first, then the rest. AQ_DRM_DEVICES only matters when there is
  # more than one GPU to order; a single-GPU host autodetects (robust to any minor).
  orderedGpus = (lib.filter (g: g.primary) gpus) ++ (lib.filter (g: !g.primary) gpus);
  drmDevices = lib.concatMapStringsSep ":" (g: "/dev/dri/by-canvas/${aliasName g.busId}") orderedGpus;
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

    debug.disable_logs = true;
  };
}
