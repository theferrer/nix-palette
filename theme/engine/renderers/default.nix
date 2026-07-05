{
  fragments = {
    kitty = {
      file = "kitty.conf";
      render = import ./kitty.nix;
    };
    hyprland = {
      file = "hyprland.conf";
      render = import ./hyprland.nix;
    };
  };

  files = {
    bat = import ./bat.nix;
    btop = import ./btop.nix;
  };
}
