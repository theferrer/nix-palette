{ config, pkgs, ... }:
{

  home.packages = with pkgs; [
    exiftool
    ffmpegthumbnailer
    poppler-utils
    chafa
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
      manager = {
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
        cache_dir = "";
      };

      opener = {
        edit = [
          {
            exec = ''$EDITOR "$@"'';
            block = true;
            for = "unix";
          }
        ];
        open = [
          {
            exec = ''xdg-open "$@"'';
            desc = "Open";
          }
        ];
        reveal = [
          {
            exec = ''nemo "$@"'';
            desc = "Reveal";
            for = "linux";
          }
        ];
        extract = [
          {
            exec = ''unar "$1"'';
            desc = "Extract here";
          }
        ];
        play = [
          {
            exec = ''mpv "$@"'';
            orphan = true;
            for = "unix";
          }
        ];
      };

      open = {
        rules = [
          {
            name = "*/";
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
            name = "*";
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
