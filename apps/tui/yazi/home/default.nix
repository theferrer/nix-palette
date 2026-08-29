{ config, pkgs, ... }:
{

  home.packages = with pkgs; [
    exiftool
    ffmpegthumbnailer
    poppler-utils
    # Image preview picks an adapter at startup. In a terminal that speaks the
    # kitty graphics protocol yazi draws inline and needs none of these, but
    # when it cannot negotiate one it falls back to the X11/Wayland overlay
    # adapter (ueberzugpp) and then to chafa's unicode blocks. Without either
    # installed that chain dead-ends and images render as bare metadata, which
    # reads like a broken previewer rather than a missing dependency.
    ueberzugpp
    chafa
    imagemagick
    glow
    jless
    hexyl
    fontpreview
    unar
  ];

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    enableFishIntegration = config.programs.fish.enable;
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;

    settings = {
      # Schema notes for yazi >= 25.5: this table was `manager`, openers took
      # `exec` rather than `run`, and open rules matched on `name` instead of
      # `url`. Only the last one is a hard parse error; the other two fail
      # silently, so the config looks fine while every setting in it is
      # ignored. If yazi ever prints "continue with preset settings" on
      # startup, that is this file failing to parse, not a broken install.
      mgr = {
        layout = [
          1
          4
          3
        ];
        sort_by = "alphabetical";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = false;
        show_symlink = true;
      };

      preview = {
        tab_size = 2;
        max_width = 600;
        max_height = 900;
      };

      opener = {
        edit = [
          {
            run = ''$EDITOR "$@"'';
            block = true;
            for = "unix";
          }
        ];
        open = [
          {
            run = ''xdg-open "$@"'';
            desc = "Open";
          }
        ];
        reveal = [
          {
            run = ''nemo "$@"'';
            desc = "Reveal";
            for = "linux";
          }
        ];
        extract = [
          {
            run = ''unar "$1"'';
            desc = "Extract here";
          }
        ];
        play = [
          {
            run = ''mpv "$@"'';
            orphan = true;
            for = "unix";
          }
        ];
      };

      open = {
        rules = [
          {
            url = "*/";
            use = [
              "edit"
              "open"
              "reveal"
            ];
          }
          {
            mime = "text/*";
            use = [
              "edit"
              "reveal"
            ];
          }
          {
            mime = "image/*";
            use = [
              "open"
              "reveal"
            ];
          }
          {
            mime = "video/*";
            use = [
              "play"
              "reveal"
            ];
          }
          {
            mime = "audio/*";
            use = [
              "play"
              "reveal"
            ];
          }
          {
            mime = "inode/x-empty";
            use = [
              "edit"
              "reveal"
            ];
          }
          {
            mime = "application/json";
            use = [
              "edit"
              "reveal"
            ];
          }
          {
            mime = "*/javascript";
            use = [
              "edit"
              "reveal"
            ];
          }
          {
            mime = "application/zip";
            use = [
              "extract"
              "reveal"
            ];
          }
          {
            mime = "application/gzip";
            use = [
              "extract"
              "reveal"
            ];
          }
          {
            mime = "application/x-tar";
            use = [
              "extract"
              "reveal"
            ];
          }
          {
            mime = "application/x-bzip";
            use = [
              "extract"
              "reveal"
            ];
          }
          {
            mime = "application/x-bzip2";
            use = [
              "extract"
              "reveal"
            ];
          }
          {
            mime = "application/x-7z-compressed";
            use = [
              "extract"
              "reveal"
            ];
          }
          {
            mime = "application/x-rar";
            use = [
              "extract"
              "reveal"
            ];
          }
          {
            url = "*";
            use = [
              "open"
              "reveal"
            ];
          }
        ];
      };

      tasks = {
        micro_workers = 5;
        macro_workers = 10;
        bizarre_retry = 5;
      };
    };
  };
}
