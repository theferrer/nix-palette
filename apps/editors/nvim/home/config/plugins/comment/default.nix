{
  imports = [
  ];

  programs.nixvim.plugins = {
    comment = {
      enable = true;
      settings = {
        opleader = {
          line = "<Leader>k";
          block = "<Leader>l";
        };
        toggler = {
          line = "<Leader>k";
          block = "<Leader>l";
        };
      };
    };
    ts-context-commentstring = {
      enable = true;
      settings = {
        enable_autocmd = false;
      };
    };
  };
}
