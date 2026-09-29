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
lib.mkIf (canvasLib.isActive config "comfyui") {
  environment.systemPackages = [
    (import ./package.nix {
      inherit pkgs lib;
      inherit gpus;
    })
    (pkgs.writers.writePython3Bin "comfyui-run" {
      # The script's own line lengths are not worth a build failure.
      flakeIgnore = [ "E501" ];
    } (builtins.readFile ./comfyui-run.py))
    # API-format starting points for comfyui-run, tested against the `core`
    # models: /run/current-system/sw/share/comfyui/workflows.
    (pkgs.runCommand "comfyui-workflows" { } ''
      mkdir -p $out/share/comfyui
      cp -r ${./workflows} $out/share/comfyui/workflows
    '')
  ];

  # ROCm reaches the card through /dev/kfd, owned by `render` with no logind
  # ACL for the seat. See apps/ai/ace-step.
  users.users.${config.canvas.machine.primaryUser}.extraGroups = lib.mkIf hasAmd [
    "render"
    "video"
  ];
}
