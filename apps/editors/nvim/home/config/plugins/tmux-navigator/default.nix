{
  programs.nixvim.plugins.tmux-navigator = {
    enable = true;
    settings = {
      disable_when_zoomed = 1;
      preserve_zoom = 1;
    };
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<C-h>";
      action = "<cmd>TmuxNavigateLeft<cr>";
      options = {
        desc = "Go to Left Window";
      };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<cmd>TmuxNavigateDown<cr>";
      options = {
        desc = "Go to Lower Window";
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<cmd>TmuxNavigateUp<cr>";
      options = {
        desc = "Go to Upper Window";
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<cmd>TmuxNavigateRight<cr>";
      options = {
        desc = "Go to Right Window";
      };
    }
    {
      mode = "n";
      key = "<C-\\>";
      action = "<cmd>TmuxNavigatePrevious<cr>";
      options = {
        desc = "Go to Previous Window";
      };
    }
  ];
}
