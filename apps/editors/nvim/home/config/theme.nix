{
  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
        term_colors = true;

        integrations = {
          telescope = {
            enabled = true;
            style = "nvchad";
          };
          treesitter = true;
          lsp_trouble = true;
          which_key = true;
          indent_blankline = {
            enabled = true;
            colored_indent_levels = false;
          };
          native_lsp = {
            enabled = true;
            virtual_text = {
              errors = [ "italic" ];
              hints = [ "italic" ];
              warnings = [ "italic" ];
              information = [ "italic" ];
            };
            underlines = {
              errors = [ "underline" ];
              hints = [ "underline" ];
              warnings = [ "underline" ];
              information = [ "underline" ];
            };
            inlay_hints = {
              background = true;
            };
          };
          cmp = true;
          gitsigns = true;
          notify = true;
          mini = false;
          noice = true;
        };
      };
    };
  };
}
