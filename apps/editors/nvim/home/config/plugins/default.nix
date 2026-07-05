{
  imports = [

    ./web-devicons
    ./lsp
    ./cmp
    ./treesitter
    ./telescope

    ./neo-tree
    ./yazi
    ./oil

    ./alpha
    ./lualine
    ./bufferline
    ./which-key
    ./legendary
    ./comment
    ./indent-blankline
    ./noice
    ./notify

    ./tmux-navigator
    ./harpoon

    ./gitsigns
    ./neotest
    ./debug
    ./trouble
    ./todo-comments
    ./snippets

    ./packer
  ];

  programs.nixvim.plugins = {
    nix.enable = true;
    mini = {
      enable = true;
      modules = {
        ai = {
          n_lines = 500;
          search_method = "cover_or_next";
          custom_objects = { };
        };
        indentscope = {
          symbol = "|";
          options.try_as_border = true;
        };
        icons.style = "glyph";
      };
      mockDevIcons = true;
    };
    nvim-autopairs.enable = true;
    notify = {
      enable = true;
      settings.backgroundColour = "#000000";
    };
  };
}
