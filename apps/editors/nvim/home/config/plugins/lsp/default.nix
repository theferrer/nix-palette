{
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {

        gopls.enable = true;
        intelephense = {
          enable = true;
          package = null;
        };
        ts_ls.enable = true;
        nil_ls.enable = true;
        rust_analyzer = {

          enable = true;
          installCargo = false;
          installRustc = false;
        };

        html.enable = true;
        cssls.enable = true;
        eslint.enable = true;
        jsonls.enable = true;
      };

      keymaps = {
        diagnostic = {
          "]d" = "goto_next";
          "[d" = "goto_prev";
        };
        lspBuf = {
          "K" = "hover";
          "gd" = "definition";
          "gr" = "references";
          "<leader>ca" = "code_action";
          "<leader>rn" = "rename";
        };
      };
    };

    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lspFallback = true;
        };
        formatters_by_ft = {
          go = [ "gofumpt" ];
          javascript = [ "prettier" ];
          typescript = [ "prettier" ];
          nix = [ "alejandra" ];
          lua = [ "stylua" ];
          rust = [ "rustfmt" ];
        };
      };
    };
  };
}
