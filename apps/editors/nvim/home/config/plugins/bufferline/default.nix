{
  programs.nixvim.plugins.bufferline = {
    enable = true;
    settings = {
      options = {
        mode = "buffers";
        themable = true;
        numbers = "none";
        close_command = "bdelete! %d";
        right_mouse_command = "bdelete! %d";
        left_mouse_command = "buffer %d";
        indicator = {
          icon = "▎";
          style = "icon";
        };
        buffer_close_icon = "󰅖";
        modified_icon = "●";
        close_icon = "";
        left_trunc_marker = "";
        right_trunc_marker = "";
        max_name_length = 30;
        truncate_names = true;
        tab_size = 21;
        diagnostics = "nvim_lsp";
        diagnostics_indicator = ''
          function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end
        '';
        color_icons = true;
        show_buffer_icons = true;
        show_buffer_close_icons = true;
        show_close_icon = true;
        show_tab_indicators = true;
        persist_buffer_sort = true;
        separator_style = "slant";
        always_show_bufferline = true;
        hover = {
          enabled = true;
          delay = 200;
          reveal = [ "close" ];
        };
        sort_by = "insert_after_current";
        offsets = [
          {
            filetype = "neo-tree";
            text = "File Explorer";
            text_align = "center";
            separator = true;
          }
        ];
      };
    };
  };
}
