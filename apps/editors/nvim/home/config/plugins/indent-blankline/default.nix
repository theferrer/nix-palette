{
  programs.nixvim.plugins.indent-blankline = {
    enable = true;
    settings = {
      indent = {
        char = "│";
        tab_char = "│";
        smart_indent_cap = true;
      };
      scope = {
        enabled = true;
        char = "│";
        show_start = true;
        show_end = false;
        injected_languages = false;
        highlight = [
          "Function"
          "Label"
        ];
        priority = 500;
      };
      exclude = {
        buftypes = [
          "terminal"
          "nofile"
          "quickfix"
          "prompt"
        ];
        filetypes = [
          "alpha"
          "dashboard"
          "neo-tree"
          "Trouble"
          "trouble"
          "notify"
          "toggleterm"
          "lspinfo"
          "packer"
          "checkhealth"
          "help"
          "man"
          "gitcommit"
          "TelescopePrompt"
          "TelescopeResults"
          "oil"
          ""
        ];
      };
    };
  };
}
