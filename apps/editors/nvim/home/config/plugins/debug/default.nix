{
  programs.nixvim.plugins = {
    dap = {
      enable = true;
    };
    dap-ui.enable = true;
    dap-virtual-text.enable = true;
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>db";
      action = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
      options = {
        desc = "Toggle Breakpoint";
      };
    }
    {
      mode = "n";
      key = "<leader>dc";
      action = "<cmd>lua require('dap').continue()<CR>";
      options = {
        desc = "Continue";
      };
    }
    {
      mode = "n";
      key = "<leader>du";
      action = "<cmd>lua require('dapui').toggle({})<CR>";
      options = {
        desc = "Debug UI";
      };
    }
  ];
}
