{
  config,
  lib,
  canvasLib,
  ...
}:
let
  user = config.canvas.machine.primaryUser;
in
lib.mkIf (canvasLib.isActive config "1password") {
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = lib.optional (user != null) user;
  };
}
