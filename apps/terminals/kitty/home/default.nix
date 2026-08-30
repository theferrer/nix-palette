{
  config,
  pkgs,
  ...
}:
let
  # Claude Code runs in a tmux on another machine, and the way in for an image
  # is a file path, not a paste: a paste over a PTY carries text, and the
  # terminal's own image handling needs the *local* terminal to hand over the
  # data, which it cannot do when the program is on the far end of an SSH
  # connection. kitty's OSC 5522 clipboard kitten does not rescue this either
  # -- that protocol is two-way, so a multiplexer has to implement it to route
  # the reply back to the right pane, and tmux does not.
  #
  # So push instead of pull: take the image off this machine's clipboard and
  # write it where the remote session can read it. Overwrites a fixed name so
  # a static key binding can type the path.
  clipboard-image-to = pkgs.writeShellApplication {
    name = "clipboard-image-to";
    runtimeInputs = with pkgs; [
      wl-clipboard
      openssh
      libnotify
    ];
    text = ''
      host="''${1:?usage: clipboard-image-to <host> [remote-path]}"
      remote="''${2:-inbox/latest.png}"

      if ! wl-paste --list-types 2>/dev/null | grep -q '^image/'; then
        notify-send -u critical "clipboard-image-to" "No image on the clipboard"
        exit 1
      fi

      # Both remote commands interpolate $remote on this side deliberately --
      # the path is chosen here, not there. Splitting mkdir from the write
      # keeps the quoting legible; with ControlMaster the second call reuses
      # the first one's connection and costs nothing.
      # shellcheck disable=SC2029
      if ssh "$host" "mkdir -p \"\$(dirname '$remote')\"" \
        && wl-paste --type image/png | ssh "$host" "cat > '$remote'"; then
        notify-send "clipboard-image-to" "Sent to $host:$remote"
      else
        notify-send -u critical "clipboard-image-to" "Failed to send to $host"
        exit 1
      fi
    '';
  };
in
{
  home.packages = [ clipboard-image-to ];

  programs.kitty = {
    enable = true;

    shellIntegration = {
      enableBashIntegration = config.programs.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    settings = {
      background_opacity = "0.80";
      url_style = "double";
      copy_on_select = "clipboard";
      open_url_with = "default";
      enable_audio_bell = false;
      window_padding_width = 12;
    };

    # Colors come from DankMaterialShell's matugen run (regenerated from the
    # wallpaper); the files are written on theme change and don't exist until
    # then, which kitty tolerates with a warning.
    extraConfig = ''
      include ${config.xdg.configHome}/kitty/dank-theme.conf
      include ${config.xdg.configHome}/kitty/dank-tabs.conf
    '';

    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+alt+c" = "copy_to_clipboard";
      "ctrl+alt+v" = "paste_from_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";

      "ctrl+shift+up" = "increase_font_size";
      "ctrl+shift+down" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";

      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+n" = "new_os_window";
      "ctrl+shift+w" = "close_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      "ctrl+shift+f" = "move_window_forward";
      "ctrl+shift+b" = "move_window_backward";
      "ctrl+shift+`" = "move_window_to_top";
      "ctrl+shift+1" = "first_window";
      "ctrl+shift+2" = "second_window";
      "ctrl+shift+3" = "third_window";
      "ctrl+shift+4" = "fourth_window";
      "ctrl+shift+5" = "fifth_window";
      "ctrl+shift+6" = "sixth_window";
      "ctrl+shift+7" = "seventh_window";
      "ctrl+shift+8" = "eighth_window";
      "ctrl+shift+9" = "ninth_window";
      "ctrl+shift+0" = "tenth_window";

      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+l" = "next_layout";
      "ctrl+shift+." = "move_tab_forward";
      "ctrl+shift+," = "move_tab_backward";
      "ctrl+shift+alt+t" = "set_tab_title";
    };
  };
}
