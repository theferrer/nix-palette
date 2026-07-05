{
  programs.nixvim.plugins.neotest = {
    enable = true;
    adapters = {
      go.enable = true;
      phpunit.enable = true;
      jest.enable = true;
      vitest.enable = true;
    };
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>tr";
      action = "<cmd>lua require('neotest').run.run()<CR>";
      options = {
        desc = "Run Nearest Test";
      };
    }
    {
      mode = "n";
      key = "<leader>tt";
      action = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>";
      options = {
        desc = "Run File Tests";
      };
    }
    {
      mode = "n";
      key = "<leader>ts";
      action = "<cmd>lua require('neotest').summary.toggle()<CR>";
      options = {
        desc = "Toggle Test Summary";
      };
    }
  ];
}
