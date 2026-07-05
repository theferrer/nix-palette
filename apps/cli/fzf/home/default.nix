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

    # Leave Ctrl-R to the history manager (atuin); fzf keeps Ctrl-T and Alt-C.
    historyWidget.command = "";

    defaultCommand = "${lib.getExe pkgs.fd} --type=f --hidden --exclude=.git";
    defaultOptions = [
      "--height=30%"
      "--layout=reverse"
      "--info=inline"
    ];
  };
}
