{
  synthppuccin = {
    colors = import ./synthppuccin/colors.nix;
    wallpaper = ./synthppuccin/wallpaper.jpg;
    gui = {
      font = {
        name = "Inter";
        size = 11;
      };
      cursor = {
        name = "catppuccin-mocha-dark-cursors";
        size = 24;
      };
      icons.name = "Papirus-Dark";
      gtkTheme = "catppuccin-mocha";
    };
  };
}
