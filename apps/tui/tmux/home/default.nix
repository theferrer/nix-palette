{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    historyLimit = 100000;
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
      set-option -sa terminal-overrides ",xterm*:Tc"
      set -g mouse on

      set -g base-index 1
      set -g pane-base-index 1
      setw -g mode-keys vi
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      set -g default-terminal "tmux-256color"
      set -g allow-passthrough on

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
    '';
  };
}
