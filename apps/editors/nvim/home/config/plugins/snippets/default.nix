{ pkgs, ... }:
{
  programs.nixvim.plugins.luasnip = {
    enable = true;
    settings = {
      enable_autosnippets = true;
      store_selection_keys = "<Tab>";
    };
    fromVscode = [
      {
        lazyLoad = true;
        paths = "${pkgs.vimPlugins.friendly-snippets}";
      }
    ];
  };

  programs.nixvim.keymaps = [
    {
      mode = [
        "i"
        "s"
      ];
      key = "<Tab>";
      action = "<cmd>lua require('luasnip').expand_or_jump()<cr>";
      options = {
        silent = true;
        desc = "Expand or jump snippet";
      };
    }
    {
      mode = [
        "i"
        "s"
      ];
      key = "<S-Tab>";
      action = "<cmd>lua require('luasnip').jump(-1)<cr>";
      options = {
        silent = true;
        desc = "Jump back in snippet";
      };
    }
  ];
}
