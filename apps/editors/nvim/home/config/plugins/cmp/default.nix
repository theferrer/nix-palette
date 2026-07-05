{
  programs.nixvim.plugins = {

    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp_luasnip.enable = true;
    cmp-cmdline.enable = true;
    cmp-git.enable = true;
    cmp-emoji.enable = true;
    cmp-treesitter.enable = true;

    cmp-npm.enable = true;
    cmp-nvim-lua.enable = true;

    cmp = {
      enable = true;
      autoEnableSources = false;
      settings = {
        experimental = {
          ghost_text = true;
        };
        completion = {
          completeopt = "menu,menuone,noinsert";
        };
        window = {
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
            col_offset = -3;
            side_padding = 0;
          };
          documentation = {
            border = [
              "╭"
              "─"
              "╮"
              "│"
              "╯"
              "─"
              "╰"
              "│"
            ];
            winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None";
          };
        };
        sources = [
          {
            name = "nvim_lsp";
            priority = 1000;
            max_item_count = 20;
          }
          {
            name = "luasnip";
            priority = 900;
            max_item_count = 5;
          }
          {
            name = "path";
            priority = 700;
            max_item_count = 10;
          }
          {
            name = "buffer";
            priority = 600;
            max_item_count = 5;
            option = {
              get_bufnrs.__raw = "function() return vim.api.nvim_list_bufs() end";
            };
          }
          {
            name = "nvim_lua";
            priority = 500;
            max_item_count = 5;
          }
          {
            name = "treesitter";
            priority = 400;
            max_item_count = 5;
          }
          {
            name = "git";
            priority = 300;
            max_item_count = 5;
          }
          {
            name = "emoji";
            priority = 200;
            max_item_count = 3;
          }
        ];
        formatting = {
          expandable_indicator = true;
          fields = [
            "kind"
            "abbr"
            "menu"
          ];
          format = ''
            function(entry, vim_item)
              local kind_icons = {
                Text = "",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰇽",
                Variable = "󰂡",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "󰅲",
              }

              vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
                nvim_lua = "[Lua]",
                treesitter = "[TS]",
                git = "[Git]",
                emoji = "[Emoji]",
                npm = "[NPM]",
              })[entry.source.name]

              return vim_item
            end
          '';
        };
        mapping = {
          "<Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif require("luasnip").expand_or_jumpable() then
                require("luasnip").expand_or_jump()
              else
                fallback()
              end
            end, {"i", "s"})
          '';
          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif require("luasnip").jumpable(-1) then
                require("luasnip").jump(-1)
              else
                fallback()
              end
            end, {"i", "s"})
          '';
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = ''
            cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = false,
            })
          '';
          "<C-y>" = "cmp.mapping.confirm({ select = true })";
        };
        snippet.expand = ''
          function(args)
            require("luasnip").lsp_expand(args.body)
          end
        '';
      };
    };
  };

  programs.nixvim.extraConfigLua = ''
    local cmp = require("cmp")

    -- Use buffer source for `/` and `?` (search)
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (commands)
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      }),
      matching = { disallow_symbol_nonprefix_matching = false }
    })
  '';
}
