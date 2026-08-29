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
  graphical = conf.canvas.resolved.graphical or false;
  styleName = conf.canvas.style.name or null;
  theme =
    if styleName != null && themes ? ${styleName} then
      themes.${styleName}
    else
      themes.${lib.head (lib.attrNames themes)};
  gui = theme.gui or null;

  cursorPackages = {
    "catppuccin-mocha-dark-cursors" = pkgs.catppuccin-cursors.mochaDark;
    "catppuccin-latte-light-cursors" = pkgs.catppuccin-cursors.latteLight;
    "nordzy-cursors" = pkgs.nordzy-cursor-theme;
    "Bibata-Modern-Classic" = pkgs.bibata-cursors;
    "capitaine-cursors" = pkgs.capitaine-cursors;
  };

  iconPackages = {
    "Papirus-Dark" = pkgs.papirus-icon-theme;
    "Nordzy" = pkgs.nordzy-icon-theme;
  };

in
lib.mkIf (graphical && gui != null) {
  home = {
    pointerCursor = {
      enable = true;
      inherit (gui.cursor) name size;
      gtk.enable = true;
      x11.enable = true;
      package = cursorPackages.${gui.cursor.name} or pkgs.vanilla-dmz;
    };

    packages = [ pkgs.glib ];

    sessionVariables = {

      GTK_USE_PORTAL = "1";

      QT_AUTO_SCREEN_SCALE_FACTOR = "1";

      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      DISABLE_QT5_COMPAT = "0";
      CALIBRE_USE_DARK_PALETTE = "1";
      QT_ICON_THEME = gui.icons.name;
    };
  };

  xdg.systemDirs.data =
    let
      schema = pkgs.gsettings-desktop-schemas;
    in
    [ "${schema}/share/gsettings-schemas/${schema.name}" ];

  gtk = {
    enable = true;
    gtk4.theme = null;

    font = {
      inherit (gui.font) name size;
    };

    # Matugen (gtkThemingEnabled) owns the GTK *colours*: it writes
    # ~/.config/gtk-3.0/gtk.css. But it only emits libadwaita/GTK4 variable
    # names, which GTK3 ignores except for a handful of theme_unfocused_*
    # aliases -- so a GTK3 app rendered in stock Adwaita grey while focused and
    # jumped to matugen's colours when it lost focus. The base *theme* has to
    # be declared separately for those names to mean anything, and adw-gtk3 is
    # the one that maps them; DMS's own gtk.sh looks for its assets by name.
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      inherit (gui.icons) name;
      package = iconPackages.${gui.icons.name} or pkgs.adwaita-icon-theme;
    };

    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      extraConfig = ''
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
      '';
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "appmenu:none";

      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";

      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
      gtk-error-bell = 0;

      gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";

      gtk-button-images = 1;
      gtk-menu-images = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "appmenu:none";

      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";

      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
      gtk-error-bell = 0;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
