{
  programs.nixvim.plugins.neo-tree = {
    enable = true;
    settings = {
      sources = [
        "filesystem"
        "buffers"
        "git_status"
      ];
      close_if_last_window = false;

      window = {
        position = "left";
        width = 40;
      };

      filesystem = {
        follow_current_file = {
          enabled = false;
        };
        group_empty_dirs = false;
        hijack_netrw_behavior = "open_default";
      };
    };
  };
}
