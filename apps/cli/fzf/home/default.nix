{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.fzf = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableFishIntegration = config.programs.fish.enable;

    defaultCommand = "${lib.getExe pkgs.fd} --type=f --hidden --exclude=.git";
    defaultOptions = [
      "--height=30%"
      "--layout=reverse"
      "--info=inline"
    ];
  };
}
