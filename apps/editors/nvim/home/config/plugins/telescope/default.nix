{
  imports = [
    ./keymaps.nix
  ];

  programs.nixvim.plugins.telescope = {
    enable = true;
  };
}
