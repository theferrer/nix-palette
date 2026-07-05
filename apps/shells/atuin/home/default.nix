{
  config,
  lib,
  osConfig ? null,
  ...
}:
let
  conf = if osConfig != null then osConfig else config;
  atuinKey = conf.canvas.secrets."atuin/key" or null;
in
{
  programs.atuin = {
    enable = true;

    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableNushellIntegration = config.programs.nushell.enable;

    flags = [ "--disable-up-arrow" ];
    settings = {
      dialect = "uk";
      show_preview = true;
      inline_height = 30;
      style = "compact";
      update_check = false;
    }
    // lib.optionalAttrs (atuinKey != null) { key_path = atuinKey; };
  };
}
