{
  programs.nixvim.plugins.gitsigns = {
    enable = true;
    settings = {
      signs = {
        add = {
          text = "│";
        };
        change = {
          text = "│";
        };
        delete = {
          text = "_";
        };
        topdelete = {
          text = "‾";
        };
        changedelete = {
          text = "~";
        };
        untracked = {
          text = "┆";
        };
      };
      signcolumn = true;
      numhl = false;
      linehl = false;
      word_diff = false;
      watch_gitdir = {
        follow_files = true;
      };
      auto_attach = true;
      attach_to_untracked = false;
      current_line_blame = false;
      current_line_blame_opts = {
        virt_text = true;
        virt_text_pos = "eol";
        delay = 1000;
        ignore_whitespace = false;
        virt_text_priority = 100;
      };
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>";
      sign_priority = 6;
      update_debounce = 100;
      status_formatter = null;
      max_file_length = 40000;
      preview_config = {
        border = "single";
        style = "minimal";
        relative = "cursor";
        row = 0;
        col = 1;
      };
    };
  };

  programs.nixvim.keymaps = [

    {
      mode = "n";
      key = "]c";
      action = ''
        function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() require('gitsigns').next_hunk() end)
          return '<Ignore>'
        end
      '';
      options = {
        expr = true;
        desc = "Next git hunk";
      };
    }
    {
      mode = "n";
      key = "[c";
      action = ''
        function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() require('gitsigns').prev_hunk() end)
          return '<Ignore>'
        end
      '';
      options = {
        expr = true;
        desc = "Previous git hunk";
      };
    }

    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>hs";
      action = "<cmd>Gitsigns stage_hunk<CR>";
      options = {
        desc = "Stage hunk";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>hr";
      action = "<cmd>Gitsigns reset_hunk<CR>";
      options = {
        desc = "Reset hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>hS";
      action = "<cmd>Gitsigns stage_buffer<CR>";
      options = {
        desc = "Stage buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>hu";
      action = "<cmd>Gitsigns undo_stage_hunk<CR>";
      options = {
        desc = "Undo stage hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>hR";
      action = "<cmd>Gitsigns reset_buffer<CR>";
      options = {
        desc = "Reset buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>hp";
      action = "<cmd>Gitsigns preview_hunk<CR>";
      options = {
        desc = "Preview hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>hb";
      action = "function() require('gitsigns').blame_line{full=true} end";
      options = {
        desc = "Blame line";
      };
    }
    {
      mode = "n";
      key = "<leader>tb";
      action = "<cmd>Gitsigns toggle_current_line_blame<CR>";
      options = {
        desc = "Toggle line blame";
      };
    }
    {
      mode = "n";
      key = "<leader>hd";
      action = "<cmd>Gitsigns diffthis<CR>";
      options = {
        desc = "Diff this";
      };
    }
    {
      mode = "n";
      key = "<leader>hD";
      action = "function() require('gitsigns').diffthis('~') end";
      options = {
        desc = "Diff this ~";
      };
    }
    {
      mode = "n";
      key = "<leader>td";
      action = "<cmd>Gitsigns toggle_deleted<CR>";
      options = {
        desc = "Toggle deleted";
      };
    }
  ];
}
