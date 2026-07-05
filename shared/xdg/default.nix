{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
let
  conf = if osConfig != null then osConfig else config;
  capabilityMap = conf.canvas.resolved.capabilityMap or { };

  browser = [
    "text/html"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/ftp"
    "x-scheme-handler/about"
    "x-scheme-handler/unknown"
  ];

  code = [
    "application/json"
    "text/english"
    "text/plain"
    "text/x-makefile"
    "text/x-c++hdr"
    "text/x-c++src"
    "text/x-chdr"
    "text/x-csrc"
    "text/x-java"
    "text/x-moc"
    "text/x-pascal"
    "text/x-tcl"
    "text/x-tex"
    "application/x-shellscript"
    "text/x-c"
    "text/x-c++"
  ];

  video = [
    "video/mp4"
    "video/x-matroska"
    "video/webm"
    "video/quicktime"
    "video/x-msvideo"
    "video/x-flv"
    "video/mpeg"
    "video/x-ms-wmv"
    "video/3gpp"
    "video/ogg"
    "video/x-ogm+ogg"
    "video/x-theora+ogg"
    "video/avi"
    "video/x-m4v"
  ];

  audio = [
    "audio/mpeg"
    "audio/flac"
    "audio/ogg"
    "audio/x-vorbis+ogg"
    "audio/x-flac+ogg"
    "audio/x-opus+ogg"
    "audio/opus"
    "audio/wav"
    "audio/x-wav"
    "audio/aac"
    "audio/x-m4a"
    "audio/mp4"
    "audio/webm"
    "audio/x-aiff"
    "audio/x-ape"
    "audio/x-matroska"
    "audio/x-musepack"
  ];

  images = [
    "image/jpeg"
    "image/png"
    "image/gif"
    "image/webp"
    "image/svg+xml"
    "image/bmp"
    "image/tiff"
    "image/avif"
    "image/heic"
    "image/heif"
    "image/x-icon"
    "image/vnd.microsoft.icon"
    "image/jxl"
  ];

  desktopFiles = {
    firefox = "firefox.desktop";
    chromium = "chromium.desktop";
    google-chrome = "google-chrome.desktop";
    brave = "brave-browser.desktop";
    vivaldi = "vivaldi-stable.desktop";

    nvim = "nvim.desktop";
    vscode = "code.desktop";

    thunar = "thunar.desktop";
    nemo = "nemo.desktop";

    mpv = "mpv.desktop";
    vlc = "vlc.desktop";
    celluloid = "io.github.celluloid_player.Celluloid.desktop";

    viewnior = "viewnior.desktop";
    imv = "imv.desktop";

    zathura = "org.pwmt.zathura.desktop";
    evince = "org.gnome.Evince.desktop";
  };

  desktopFor = app: lib.optional (app != null) (desktopFiles.${app} or "${app}.desktop");
  appOf = cap: capabilityMap.${cap} or null;
  assocFor = cap: types: lib.genAttrs types (_: desktopFor (appOf cap));

  associations =
    (assocFor "editor" code)
    // (assocFor "video-player" video)
    // (assocFor "audio-player" audio)
    // (assocFor "image-viewer" images)
    // (assocFor "browser" browser)
    // {
      "application/pdf" = desktopFor (appOf "pdf-viewer");
      "inode/directory" = desktopFor (appOf "file-manager");

      "x-scheme-handler/spotify" = [ "spotify.desktop" ];
      "x-scheme-handler/discord" = [ "Discord.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      "x-scheme-handler/magnet" = [ "org.qbittorrent.qBittorrent.desktop" ];
      "x-scheme-handler/steam" = [ "steam.desktop" ];

      "application/zip" = [ "xarchiver.desktop" ];
      "application/x-7z-compressed" = [ "xarchiver.desktop" ];
      "application/x-rar" = [ "xarchiver.desktop" ];
      "application/x-tar" = [ "xarchiver.desktop" ];
      "application/x-bzip2" = [ "xarchiver.desktop" ];
      "application/x-gzip" = [ "xarchiver.desktop" ];
    };
in
{
  home.packages = [ pkgs.xdg-utils ];

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;

      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      desktop = "${config.home.homeDirectory}/desktop";
      videos = "${config.home.homeDirectory}/media/videos";
      music = "${config.home.homeDirectory}/media/music";
      pictures = "${config.home.homeDirectory}/media/pictures";
      publicShare = "${config.home.homeDirectory}/public/share";
      templates = "${config.home.homeDirectory}/public/templates";

      setSessionVariables = true;

      extraConfig = {
        SCREENSHOTS = "${config.xdg.userDirs.pictures}/screenshots";
        DEV = "${config.home.homeDirectory}/dev";
      };
    };

    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}
