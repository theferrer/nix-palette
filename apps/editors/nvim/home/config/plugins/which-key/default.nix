{
  programs.nixvim.plugins.which-key = {
    enable = true;
    settings = {
      delay = 200;
      expand = 1;
      notify = false;
      preset = "modern";
      replace = {
        desc = [
          [
            "<space>"
            "SPACE"
          ]
          [
            "<leader>"
            "SPACE"
          ]
          [
            "<[cC][rR]>"
            "RETURN"
          ]
          [
            "<[tT][aA][bB]>"
            "TAB"
          ]
          [
            "<[bB][sS]>"
            "BACKSPACE"
          ]
        ];
      };
      spec = [
        {
          __unkeyed-1 = "<leader>b";
          group = "buffer";
          expand = ''
            function()
              return require("which-key.extras").expand.buf()
            end
          '';
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "code";
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "debug";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>f";
          group = "file/find";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "git";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>h";
          group = "git hunks";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "lsp";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>q";
          group = "quit/session";
        }
        {
          __unkeyed-1 = "<leader>s";
          group = "search";
        }
        {
          __unkeyed-1 = "<leader>t";
          group = "test/toggle";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>u";
          group = "ui";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>w";
          group = "windows";
          proxy = "<c-w>";
        }
        {
          __unkeyed-1 = "<leader>x";
          group = "diagnostics/quickfix";
          icon = " ";
        }
        {
          __unkeyed-1 = "[";
          group = "prev";
        }
        {
          __unkeyed-1 = "]";
          group = "next";
        }
        {
          __unkeyed-1 = "g";
          group = "goto";
        }
        {
          __unkeyed-1 = "gs";
          group = "surround";
        }
        {
          __unkeyed-1 = "z";
          group = "fold";
        }
        {
          __unkeyed-1 = "<leader><tab>";
          group = "tabs";
        }

        {
          __unkeyed-1 = "<leader>dp";
          group = "PHP debug";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>dg";
          group = "Go debug";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>dn";
          group = "Node debug";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>tp";
          group = "PHP test";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>tg";
          group = "Go test";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>tj";
          group = "JS/TS test";
          icon = " ";
        }
      ];
      win = {
        no_overlap = true;
        border = "single";
        padding = [
          1
          2
        ];
        title = true;
        title_pos = "center";
        zindex = 1000;
      };
      layout = {
        width = {
          min = 20;
        };
        spacing = 3;
      };
      keys = {
        scroll_down = "<c-d>";
        scroll_up = "<c-u>";
      };
    };
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>?";
      action = "<cmd>WhichKey<CR>";
      options = {
        desc = "Buffer Local Keymaps (which-key)";
      };
    }
    {
      mode = "n";
      key = "<c-w><space>";
      action = "<cmd>WhichKey '' c-w<CR>";
      options = {
        desc = "Window Hydra Mode (which-key)";
      };
    }
  ];
}
