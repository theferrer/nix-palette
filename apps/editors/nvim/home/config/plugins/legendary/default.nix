{ pkgs, ... }:
{
  programs.nixvim = {

    extraPlugins = with pkgs.vimPlugins; [
      legendary-nvim
    ];

    extraConfigLua = ''
      require('legendary').setup({
        -- Auto-load keymaps from which-key
        which_key = {
          auto_register = true,
        },

        -- Show command descriptions
        include_builtin = true,
        include_legendary_cmds = true,

        -- UI settings
        select_prompt = ' Legendary',
        col_separator_char = '│',

        -- Sort order
        sort = {
          frecency = {
            db_root = '/tmp/legendary',
            max_timestamps = 10,
          },
        },

        -- Extensions
        extensions = {
          nvim_tree = false,
          smart_splits = false,
          op_nvim = false,
          diffview = false,
        },
      })
    '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>fk";
        action = "<cmd>Legendary<CR>";
        options = {
          desc = "Find keymaps (Legendary)";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>fc";
        action = "<cmd>Legendary commands<CR>";
        options = {
          desc = "Find commands (Legendary)";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>fa";
        action = "<cmd>Legendary autocmds<CR>";
        options = {
          desc = "Find autocmds (Legendary)";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-p>";
        action = "<cmd>Legendary<CR>";
        options = {
          desc = "Command palette (Legendary)";
          silent = true;
        };
      }
    ];
  };
}
