{
  programs.nixvim = {
    globals.mapleader = " ";

    opts = {
      ignorecase = true;
      expandtab = false;
      mouse = "a";
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      showmode = false;
      smartcase = true;
      smartindent = true;
      signcolumn = "yes";
      tabstop = 2;
      softtabstop = 2;
      termguicolors = true;
      timeoutlen = 300;
      undofile = true;
      undolevels = 10000;
      wrap = false;
    };
  };
}
