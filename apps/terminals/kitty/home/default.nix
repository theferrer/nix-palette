{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
let
  conf = if osConfig != null then osConfig else config;
  dms = (conf.canvas.resolved.software or { }) ? dms;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

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
  #
  # Only the clipboard and notification tools differ between platforms.
  clip =
    if isDarwin then
      {
        inputs = [ pkgs.pngpaste ];
        hasImage = "pngpaste - > /dev/null 2>&1";
        paste = "pngpaste -";
        notify = ''osascript -e "display notification \"$2\" with title \"$1\""'';
        notifyFail = ''osascript -e "display notification \"$2\" with title \"$1\""'';
      }
    else
      {
        inputs = [
          pkgs.wl-clipboard
          pkgs.libnotify
        ];
        hasImage = "wl-paste --list-types 2>/dev/null | grep -q '^image/'";
        paste = "wl-paste --type image/png";
        notify = ''notify-send "$1" "$2"'';
        notifyFail = ''notify-send -u critical "$1" "$2"'';
      };

  clipboard-image-to = pkgs.writeShellApplication {
    name = "clipboard-image-to";
    runtimeInputs = clip.inputs ++ [ pkgs.openssh ];
    text = ''
      notify() { ${clip.notify}; }
      fail() { ${clip.notifyFail}; }

      host="''${1:?usage: clipboard-image-to <host> [remote-path]}"
      remote="''${2:-inbox/latest.png}"

      if ! ${clip.hasImage}; then
        fail "clipboard-image-to" "No image on the clipboard"
        exit 1
      fi

      # Both remote commands interpolate $remote on this side deliberately --
      # the path is chosen here, not there. Splitting mkdir from the write
      # keeps the quoting legible; with ControlMaster the second call reuses
      # the first one's connection and costs nothing.
      # shellcheck disable=SC2029
      if ssh "$host" "mkdir -p \"\$(dirname '$remote')\"" \
        && ${clip.paste} | ssh "$host" "cat > '$remote'"; then
        notify "clipboard-image-to" "Sent to $host:$remote"
      else
        fail "clipboard-image-to" "Failed to send to $host"
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
      # Retina at the default scale renders 11pt noticeably smaller.
      size = if isDarwin then 14 else 11;
    };

    settings = {
      background_opacity = "0.80";
      url_style = "double";
      copy_on_select = "clipboard";
      open_url_with = "default";
      enable_audio_bell = false;
      window_padding_width = 12;
    }
    // lib.optionalAttrs isDarwin {
      # The tiling WM owns the frame, as on Hyprland.
      hide_window_decorations = "titlebar-only";
      macos_quit_when_last_window_closed = true;
    };

    # With DankMaterialShell, colors come from its matugen run (regenerated
    # from the wallpaper); the files are written on theme change and don't
    # exist until then, which kitty tolerates with a warning. Without it
    # (macOS) they come from the theme engine's fragment, which theme-set
    # swaps and reloads with SIGUSR1.
    extraConfig =
      if dms then
        ''
          include ${config.xdg.configHome}/kitty/dank-theme.conf
          include ${config.xdg.configHome}/kitty/dank-tabs.conf
        ''
      else
        ''
          include ${config.xdg.configHome}/theme/current/kitty.conf
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
