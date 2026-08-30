{ pkgs, ... }:
{
  # sesh drives tmux sessions off zoxide's frecency list, so jumping to a
  # project is the same gesture as cd-ing to it. It only earns its place
  # because zoxide and fzf are already here for it to sit on top of.
  home.packages = [ pkgs.sesh ];

  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    historyLimit = 100000;
    # Native option rather than a line in extraConfig: home-manager emits its
    # own `set -g focus-events off` near the top of the generated file, so
    # setting it below would have been one line fighting another.
    # (nvim autoread, and vim-tmux-navigator stops losing track of the live pane.)
    focusEvents = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
      tmuxPlugins.cpu
      tmuxPlugins.battery
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
    ];
    extraConfig = ''
      set -g mouse on

      set -g base-index 1
      set -g pane-base-index 1
      setw -g mode-keys vi
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      set -g default-terminal "tmux-256color"
      set -g allow-passthrough on

      # terminal-features supersedes the old terminal-overrides ",xterm*:Tc"
      # that used to live at the top of this file: RGB is the same capability
      # spelled the modern way, and the rest could not be expressed there.
      #
      # sixel is the one that matters over SSH. tmux is built with sixel
      # support, but it will not emit sixel unless it knows the *outer*
      # terminal can take it, so without this line image preview inside a
      # remote tmux silently degrades to text. Kitty's own graphics protocol
      # is the wrong choice here even though kitty speaks it: tmux does not
      # track those images, so they corrupt on scroll and redraw, whereas
      # sixel it manages in its own buffer.
      set -as terminal-features ",xterm-kitty:RGB,xterm-kitty:sixel"
      set -as terminal-features ",*:clipboard,*:hyperlinks"

      # OSC 52, so a copy made inside a tmux running on the far end of an SSH
      # connection reaches the local clipboard. tmuxPlugins.yank shells out to
      # wl-copy, which does not exist on the other side of that connection, so
      # copying remotely had nowhere to go.
      set -g set-clipboard on

      # Passes kitty's keyboard protocol through, so modified keys that the
      # legacy encoding cannot express arrive intact.
      set -g extended-keys always

      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""

      set -g status-left "[#S] "
      set -g status-right " %H:%M %d-%b-%y "

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      unbind C-b
      set -g prefix C-Space
      bind C-Space send-prefix

      bind -n M-H previous-window
      bind -n M-L next-window

      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      bind -n C-M-h resize-pane -L 2
      bind -n C-M-j resize-pane -D 2
      bind -n C-M-k resize-pane -U 2
      bind -n C-M-l resize-pane -R 2

      # prefix + s over sesh: sessions, zoxide directories and tmuxinator
      # configs in one list. Replaces tmux's own session chooser, which only
      # knows about sessions that already exist.
      bind-key s run-shell "sesh connect \"$(sesh list --icons | fzf-tmux -p 80%,70% \
        --no-sort --ansi --border-label ' sesh ' --prompt '  ' \
        --header '  ^a all  ^t tmux  ^g configs  ^x zoxide  ^d kill' \
        --bind 'tab:down,btab:up' \
        --bind 'ctrl-a:change-prompt(  )+reload(sesh list --icons)' \
        --bind 'ctrl-t:change-prompt(  )+reload(sesh list -t --icons)' \
        --bind 'ctrl-g:change-prompt(  )+reload(sesh list -c --icons)' \
        --bind 'ctrl-x:change-prompt(  )+reload(sesh list -z --icons)' \
        --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(  )+reload(sesh list --icons)' \
      )\""
    '';
  };
}
