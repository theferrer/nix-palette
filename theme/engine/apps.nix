{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
let
  themes = import ../themes;
  conf = if osConfig != null then osConfig else config;
  active = conf.canvas.resolved.software or { };
  styleName = conf.canvas.style.name or null;
  defaultTheme =
    if styleName != null && themes ? ${styleName} then styleName else lib.head (lib.attrNames themes);
  colors = themes.${defaultTheme}.colors;

  renderers = import ./renderers;

  perTheme =
    mkPath: render:
    lib.mapAttrs' (name: theme: {
      name = mkPath name;
      value.text = render {
        inherit name;
        inherit (theme) colors;
      };
    }) themes;
in
lib.mkMerge [
  (lib.mkIf (active ? bat) {

    programs.bat = {
      config.theme = defaultTheme;
      themes = lib.mapAttrs (name: theme: {
        src = pkgs.writeText "${name}.tmTheme" (
          renderers.files.bat {
            inherit name;
            inherit (theme) colors;
          }
        );
      }) themes;
    };
  })

  (lib.mkIf (active ? btop) {
    programs.btop.settings.color_theme = defaultTheme;
    xdg.configFile = perTheme (name: "btop/themes/${name}.theme") renderers.files.btop;
  })

  (lib.mkIf (active ? cava) {
    programs.cava.settings.color = {
      background = "'${colors.base00}'";
      gradient = 1;
      gradient_count = 8;
      gradient_color_1 = "'${colors.base0D}'";
      gradient_color_2 = "'${colors.base0C}'";
      gradient_color_3 = "'${colors.base0B}'";
      gradient_color_4 = "'${colors.base0A}'";
      gradient_color_5 = "'${colors.base09}'";
      gradient_color_6 = "'${colors.base08}'";
      gradient_color_7 = "'${colors.base0E}'";
      gradient_color_8 = "'${colors.base0F}'";
    };
  })

  (lib.mkIf (active ? tmux) {
    programs.tmux.extraConfig = ''
      # Theme: ${defaultTheme}
      set -g status-style "bg=${colors.base01},fg=${colors.base05}"
      set -g status-left-style "bg=${colors.base0D},fg=${colors.base00},bold"
      set -g status-right-style "bg=${colors.base01},fg=${colors.base04}"

      set -g window-status-style "bg=${colors.base01},fg=${colors.base04}"
      set -g window-status-current-style "bg=${colors.base0D},fg=${colors.base00},bold"
      set -g window-status-activity-style "bg=${colors.base0A},fg=${colors.base00}"
      set -g window-status-bell-style "bg=${colors.base08},fg=${colors.base00},bold"

      set -g pane-border-style "fg=${colors.base03}"
      set -g pane-active-border-style "fg=${colors.base0D}"

      set -g message-style "bg=${colors.base0D},fg=${colors.base00},bold"
      set -g message-command-style "bg=${colors.base01},fg=${colors.base05}"

      set -g mode-style "bg=${colors.base02},fg=${colors.base05}"

      set -g clock-mode-colour "${colors.base0D}"
    '';
  })

  (lib.mkIf (active ? newsboat) {
    programs.newsboat.extraConfig = ''
      # Theme: ${defaultTheme}
      color background          default   default
      color listnormal          ${colors.base05}   default
      color listfocus           ${colors.base00}   ${colors.base0D}   bold
      color listnormal_unread   ${colors.base0D}   default   bold
      color listfocus_unread    ${colors.base00}   ${colors.base0D}   bold
      color info                ${colors.base00}   ${colors.base0B}   bold
      color article             ${colors.base05}   default

      highlight all "---.*---" ${colors.base0A}
      highlight feedlist ".*(0/0))" ${colors.base00}
      highlight article "(^Feed:.*|^Title:.*|^Author:.*)" ${colors.base0C} default bold
      highlight article "(^Link:.*|^Date:.*)" ${colors.base03} default
      highlight article "https?://[^ ]+" ${colors.base0D} default
      highlight article "^(Title):.*$" ${colors.base0D} default
      highlight article "\\[[0-9][0-9]*\\]" ${colors.base0E} default bold
      highlight article "\\[image\\ [0-9]+\\]" ${colors.base0B} default bold
      highlight article ":.*\\(link\\)$" ${colors.base0C} default
      highlight article ":.*\\(image\\)$" ${colors.base0D} default
    '';
  })
]
