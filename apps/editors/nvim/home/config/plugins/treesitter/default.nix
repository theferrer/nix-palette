{
  imports = [
  ];

  programs.nixvim.plugins = {
    treesitter = {
      enable = true;

      settings = {
        indent.enable = true;
      };
    };

    treesitter-context = {
      enable = false;
      settings = {
        mode = "cursor";
        max_lines = 3;
      };
    };

    ts-autotag = {
      enable = true;
    };
  };
}
