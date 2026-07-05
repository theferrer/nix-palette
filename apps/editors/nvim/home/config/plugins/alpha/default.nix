{
  programs.nixvim.plugins.alpha = {
    enable = true;
    settings.layout =
      let
        padding = val: {
          type = "padding";
          inherit val;
        };
      in
      [
        (padding 2)
        {
          opts = {
            hl = "Type";
            position = "center";
          };
          type = "text";
          val = [
            "  ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗  "
            "  ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║  "
            "  ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║  "
            "  ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║  "
            "  ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║  "
            "  ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝  "
          ];
        }
        (padding 2)
        {
          type = "group";
          opts.spacing = 1;
          val = [
            {
              type = "button";
              val = "  Find Files";
              on_press.__raw =

                "function() require('telescope.builtin').find_files() end";
              opts = {
                shortcut = "f";
                position = "center";
                hl_shortcut = "keyword";
                align_shortcut = "right";
                width = 50;
                cursor = 3;
                keymap = [
                  "n"
                  "f"
                  "<cmd>Telescope find_files<CR>"
                  {
                    noremap = true;
                    silent = true;
                    nowait = true;
                  }
                ];
              };
            }
            {
              type = "button";
              val = "  Recent Files";
              on_press.__raw =

                "function() require('telescope.builtin').oldfiles() end";
              opts = {
                shortcut = "r";
                position = "center";
                hl_shortcut = "keyword";
                align_shortcut = "right";
                width = 50;
                cursor = 3;
                keymap = [
                  "n"
                  "r"
                  "<cmd>Telescope oldfiles<CR>"
                  {
                    noremap = true;
                    silent = true;
                    nowait = true;
                  }
                ];
              };
            }
            {
              type = "button";
              val = "  Live Grep";
              on_press.__raw =

                "function() require('telescope.builtin').live_grep() end";
              opts = {
                shortcut = "g";
                position = "center";
                hl_shortcut = "keyword";
                align_shortcut = "right";
                width = 50;
                cursor = 3;
                keymap = [
                  "n"
                  "g"
                  "<cmd>Telescope live_grep<CR>"
                  {
                    noremap = true;
                    silent = true;
                    nowait = true;
                  }
                ];
              };
            }
            {
              type = "button";
              val = "  New file";
              on_press.__raw =

                "function() vim.cmd[[enew]] end";
              opts = {
                shortcut = "e";
                position = "center";
                hl_shortcut = "keyword";
                align_shortcut = "right";
                width = 50;
                cursor = 3;
                keymap = [
                  "n"
                  "e"
                  ":enew<CR>"
                  {
                    noremap = true;
                    silent = true;
                    nowait = true;
                  }
                ];
              };
            }
            {
              type = "button";
              val = "  File Explorer";
              on_press.__raw =

                "function() vim.cmd[[Yazi]] end";
              opts = {
                shortcut = "x";
                position = "center";
                hl_shortcut = "keyword";
                align_shortcut = "right";
                width = 50;
                cursor = 3;
                keymap = [
                  "n"
                  "x"
                  "<cmd>Yazi<CR>"
                  {
                    noremap = true;
                    silent = true;
                    nowait = true;
                  }
                ];
              };
            }
            {
              type = "button";
              val = "󰅙  Quit Neovim";
              on_press.__raw =

                "function() vim.cmd[[qa]] end";
              opts = {
                shortcut = "q";
                position = "center";
                hl_shortcut = "keyword";
                align_shortcut = "right";
                width = 50;
                cursor = 3;
                keymap = [
                  "n"
                  "q"
                  ":qa<CR>"
                  {
                    noremap = true;
                    silent = true;
                    nowait = true;
                  }
                ];
              };
            }
          ];
        }
      ];
  };
}
