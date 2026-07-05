{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    plugins = [ ];

    functions = {

      bj = "nohup $argv </dev/null &>/dev/null &";

      "." = ''
        set -l input $argv[1]
        if echo $input | grep -q '^[1-9][0-9]*$'
          set -l levels $input
          for i in (seq $levels)
            cd ..
          end
        else
          echo "Invalid input format. Please use '<number>' to go back a specific number of directories."
        end
      '';
    };

    shellInit = ''
      ${pkgs.lib.getExe pkgs.nix-your-shell} fish | source

      if set -q GHOSTTY_RESOURCES_DIR
        source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
      end

      set fish_greeting
      export "MICRO_TRUECOLOR=1"
      set -g theme_display_date no
      set -g theme_nerd_fonts yes
      set -g theme_newline_cursor yes
    '';
  };

  home.shellAliases = {
    mkdir = "mkdir -pv";
    df = "df -h";
    rs = "systemctl reboot";
    sysctl = "sudo systemctl";
    jctl = "journalctl -p 3 -xb";
    lg = "lazygit";
  };
}
