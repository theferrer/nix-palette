{
  config,
  lib,
  pkgs,
  canvasLib,
  ...
}:
let
  gpus = config.canvas.hardware.gpus;
  hasAmd = builtins.elem "amd" (map (g: g.vendor) gpus);
in
lib.mkIf (canvasLib.isActive config "ace-step") {
  environment.systemPackages = [
    (import ./package.nix {
      inherit pkgs lib;
      inherit gpus;
    })
  ];

  # ROCm reaches the card through /dev/kfd, and that node is owned by `render`
  # with no logind ACL for the seat -- unlike /dev/dri, which the active session
  # gets for free. Without the group torch reports no GPU at all, which reads
  # like a broken install rather than a permission.
  users.users.${config.canvas.machine.primaryUser}.extraGroups = lib.mkIf hasAmd [
    "render"
    "video"
  ];
}
