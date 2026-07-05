{
  programs.nixvim.plugins.harpoon = {
    enable = true;
    enableTelescope = true;
    settings = {
      global_settings = {
        save_on_toggle = false;
        save_on_change = true;
        enter_on_sendcmd = false;
        tmux_autoclose_windows = false;
        excluded_filetypes = [ "harpoon" ];
        mark_branch = false;
        tabline = false;
        tabline_prefix = "   ";
        tabline_suffix = "   ";
      };
    };
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>ha";
      action = "<cmd>lua require('harpoon.mark').add_file()<CR>";
      options = {
        desc = "Harpoon add file";
      };
    }
    {
      mode = "n";
      key = "<leader>hm";
      action = "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>";
      options = {
        desc = "Harpoon menu";
      };
    }
  ];
}
