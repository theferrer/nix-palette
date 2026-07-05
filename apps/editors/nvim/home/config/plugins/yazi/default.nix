{ config, lib, ... }:
{
  programs.nixvim.plugins.yazi = {
    enable = true;
  };

  programs.nixvim.keymaps = lib.optionals config.programs.nixvim.plugins.yazi.enable [
    {
      mode = "n";
      key = "<leader>e";
      action = "<CMD>Yazi<CR>";
      options = {
        desc = "Yazi (current file)";
      };
    }
    {
      mode = "n";
      key = "<leader>E";
      action = "<CMD>Yazi toggle<CR>";
      options = {
        desc = "Yazi (resume)";
      };
    }
  ];
}
