{
  programs.nixvim.plugins.web-devicons = {
    enable = true;
    settings = {
      override = { };
      color_icons = true;
      default = true;
      strict = true;
      variant = "dark";
    };
  };
}
