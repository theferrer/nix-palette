{ config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;

    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableZshIntegration = config.programs.zsh.enable;

    settings = {
      command = "${pkgs.fish}/bin/fish --login";

      background-opacity = 0.80;
      background-blur-radius = 10;
      cursor-style = "bar";
      window-padding-x = 12;
      window-padding-y = 12;
      window-decoration = "false";
      gtk-titlebar = false;

      window-save-state = "always";

      font-family = "JetBrains Mono";
      font-size = 12;

      link-url = true;
      copy-on-select = "clipboard";

      shell-integration-features = "no-cursor,no-sudo,no-title";

      keybind = [
        "ctrl+alt+c=copy_to_clipboard"
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+alt+v=paste_from_clipboard"
        "ctrl+shift+v=paste_from_clipboard"

        "ctrl+shift+up=increase_font_size:1"
        "ctrl+shift+down=decrease_font_size:1"
        "ctrl+shift+backspace=reset_font_size"

        "ctrl+shift+enter=new_split:right"
        "ctrl+shift+n=new_window"
        "ctrl+shift+w=close_surface"
        "ctrl+shift+right_bracket=goto_split:next"
        "ctrl+shift+left_bracket=goto_split:previous"
        "ctrl+shift+f=goto_split:next"
        "ctrl+shift+b=goto_split:previous"

        "ctrl+shift+t=new_tab"
        "ctrl+shift+q=close_tab"
        "ctrl+shift+right=next_tab"
        "ctrl+shift+left=previous_tab"
        "ctrl+shift+period=move_tab:1"
        "ctrl+shift+comma=move_tab:-1"

        "ctrl+shift+one=goto_tab:1"
        "ctrl+shift+two=goto_tab:2"
        "ctrl+shift+three=goto_tab:3"
        "ctrl+shift+four=goto_tab:4"
        "ctrl+shift+five=goto_tab:5"
        "ctrl+shift+six=goto_tab:6"
        "ctrl+shift+seven=goto_tab:7"
        "ctrl+shift+eight=goto_tab:8"
        "ctrl+shift+nine=goto_tab:9"
        "ctrl+shift+zero=goto_tab:10"
      ];
    };
  };
}
