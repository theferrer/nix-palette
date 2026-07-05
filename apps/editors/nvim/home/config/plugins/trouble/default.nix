{
  programs.nixvim.plugins.trouble = {
    enable = true;
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options = {
        desc = "Toggle Diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = "<cmd>Trouble quickfix toggle<CR>";
      options = {
        desc = "Toggle Quickfix";
      };
    }
  ];
}
