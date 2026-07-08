{

  cli-core = {
    description = "Baseline CLI toolbox present on every machine.";
    software = [
      "git"
      "curl"
      "wget"
      "ripgrep"
      "fd"
      "jq"
      "bat"
      "eza"
      "fzf"
      "zoxide"
      "starship"
      "fastfetch"
      "btop"
      "htop"
      "tealdeer"
      "direnv"
      "tmux"
      "gnupg"
      "git-lfs"
      "delta"
      "age"
      "openssl"
      "zsh"
    ];
  };

  cli-extras = {
    description = "Nice-to-have CLI utilities beyond the core.";
    software = [
      "bottom"
      "bandwhich"
      "du-dust"
      "dua"
      "duf"
      "hyperfine"
      "ncdu"
      "procs"
      "jaq"
      "ouch"
      "glow"
      "mtr"
      "lsof"
      "gdu"
      "tig"
      "tokei"
      "yq"
      "just"
      "tree"
      "file"
      "rsync"
      "trash-cli"
      "gum"
      "gping"
      "hexyl"
      "jless"
      "viu"
      "chafa"
      "doggo"
      "taskwarrior"
      "khal"
      "rclone"
    ];
  };

  nix-dev = {
    description = "Nix development and maintenance tooling.";
    software = [
      "nix-output-monitor"
      "deadnix"
      "alejandra"
      "just"
      "nh"
    ];
  };

  dev-langs = {
    description = "Language toolchains and build systems.";
    software = [
      "go"
      "rustup"
      "bun"
      "nodejs"
      "python"
      "php"
      "gcc"
      "gnumake"
      "cmake"
      "meson"
      "gopls"
      "binutils"
      "composer"
      "phpactor"
      "yarn"
      "intelephense"
    ];
  };

  dev-tools = {
    description = "Day-to-day development helpers and clients.";
    software = [
      "gh"
      "lazygit"
      "lazydocker"
      "devenv"
      "claude-code"
      "opencode"
      "codex"
      "herdr"
      "wakatime-cli"
      "git-credential-manager"
      "httpie"
      "insomnia"
      "postman"
      "bruno"
      "jupyter"
      "gh-dash"
      "gotools"
      "atuin"
      "zk"
      "android-tools"
      "comma"
    ];
  };

  dev-db = {
    description = "Database clients.";
    software = [
      "dbeaver"
      "mongodb-compass"
      "mongosh"
      "nosqlbooster4mongo"
    ];
  };

  dev-cloud = {
    description = "Cloud and Kubernetes tooling.";
    software = [
      "kubectl"
      "kubernetes-helm"
      "minikube"
      "terraform"
      "awscli"
      "google-cloud-sdk"
      "lens"
      "podman-desktop"
    ];
  };

  ides = {
    description = "Editors and IDEs beyond the adjudicated editor.";
    software = [
      "vscode"
      "micro"
      "goland"
      "phpstorm"
      "clion"
      "datagrip"
      "webstorm"
      "rustrover"
      "zed"
      "antigravity"
    ];
  };

  containers = {
    description = "Container and virtualisation runtimes.";
    software = [
      "docker"
      "docker-compose"
      "podman"
      "distrobox"
      "virt-manager"
      "podman-compose"
      "virt-viewer"
    ];
  };

  media-suite = {
    description = "Media creation and consumption applications.";
    software = [
      "vlc"
      "celluloid"
      "gimp"
      "inkscape"
      "darktable"
      "blender"
      "ffmpeg"
      "amberol"
      "loupe"
      "viewnior"
      "gthumb"
      "krita"
      "audacity"
      "handbrake"
      "obs-studio"
      "playerctl"
      "spotify"
      "yt-dlp"
      "imagemagick"
      "cava"
      "davinci-resolve-studio"
      "termusic"
      "hypnotix"
      "blanket"
      "ffmpeg-full"
      "v4l-utils"
    ];
  };

  sync-net = {
    description = "Sync, torrent and VPN clients.";
    software = [
      "syncthing"
      "syncthingtray"
      "qbittorrent"
      "openvpn"
      "wireguard"
      "protonvpn-gui"
      "networkmanager-openvpn"
    ];
  };

  office-suite = {
    description = "Office, notes and reading.";
    software = [
      "libreoffice"
      "onlyoffice"
      "xournalpp"
      "zotero"
      "calibre"
    ];
  };

  comms = {
    description = "Chat, mail and meetings.";
    software = [
      "discord"
      "slack"
      "telegram"
      "whatsapp"
      "element"
      "zoom"
      "teams"
      "thunderbird"
    ];
  };

  gaming-suite = {
    description = "Gaming platforms and performance tools.";
    software = [
      "steam"
      "lutris"
      "mangohud"
      "bottles"
      "heroic"
      "gamemode"
      "gamescope"
      "protontricks"
      "wine"
      "minecraft"
    ];
  };

  wayland-utils = {
    description = "Wayland session utilities (clipboard, idle, brightness...).";
    software = [
      "wl-ocr"
      "hyprshot"
      "hyprpicker"
      "swappy"
      "wl-clipboard"
      "cliphist"
      "wlogout"
      "hypridle"
      "hyprpaper"
      "gammastep"
      "wlsunset"
      "grim"
      "slurp"
      "grimblast"
      "brightnessctl"
      "network-manager-applet"
      "blueman"
      "pavucontrol"
      "pulsemixer"
    ];
  };

  system-utils = {
    description = "Hardware inspection and system administration.";
    software = [
      "powertop"
      "acpi"
      "dmidecode"
      "hwinfo"
      "lshw-gtk"
      "lm-sensors"
      "pciutils"
      "usbutils"
      "smartmontools"
      "sysstat"
      "gparted"
      "gnome-disk-utility"
      "mission-center"
      "iotop"
      "ntfs3g"
      "exiftool"
      "appimage-run"
      "fwupd"
      "bolt"
      "cpupower"
      "tpm2-pkcs11"
    ];
  };

  net-utils = {
    description = "Network diagnostics.";
    software = [
      "nmap"
      "wireshark"
      "iperf3"
      "traceroute"
      "whois"
      "dig"
      "netcat"
      "nethogs"
      "nload"
      "speedtest"
      "socat"
    ];
  };

  archivers = {
    description = "Archive formats coverage.";
    software = [
      "p7zip"
      "unzip"
      "zip"
      "unrar"
      "arj"
      "cabextract"
      "lhasa"
      "xarchiver"
      "file-roller"
    ];
  };

  desktop-utils = {
    description = "Small desktop helpers.";
    software = [ "yazi" ];
  };

  session-services = {
    description = "Graphical-session system services (keyring, portals helpers, splash).";
    software = [
      "flatpak"
      "gnome-keyring"
      "seahorse"
      "avahi"
      "plymouth"
      "geoclue"
    ];
  };

  hardening = {
    description = "Baseline security services.";
    software = [
      "apparmor"
      "fail2ban"
    ];
  };

  laptop-extras = {
    description = "Laptop hardware control.";
    software = [ "asusctl" ];
  };

  graphics-tools = {
    description = "GPU diagnostics and benchmarks (vendor-neutral).";
    software = [
      "glmark2"
      "mesa-demos"
      "vulkan-tools"
      "libva-utils"
      "clinfo"
      "undervolt"
      "upower"
    ];
  };

  desktop = {
    description = "Daily-driver graphical session.";
    capabilities = [
      "desktop"
      "login-manager"
      "terminal"
      "browser"
      "launcher"
      "notifications"
      "bar"
      "file-manager"
      "screenshot"
      "wallpaper"
      "screen-locker"
      "pdf-viewer"
      "image-viewer"
      "video-player"
      "audio-player"
    ];
    includes = [
      "media-suite"
      "office-suite"
      "comms"
      "wayland-utils"
      "archivers"
      "sync-net"
      "session-services"
      "desktop-utils"
      "graphics-tools"
    ];
  };

  development = {
    description = "Write, build and ship code.";
    capabilities = [
      "editor"
      "shell"
    ];
    includes = [
      "cli-core"
      "cli-extras"
      "nix-dev"
      "dev-langs"
      "dev-tools"
      "dev-db"
      "dev-cloud"
      "ides"
      "containers"
    ];
  };

  laptop = {
    description = "Portable-machine extras.";
    includes = [
      "desktop-utils"
      "laptop-extras"
    ];
  };

  gaming = {
    description = "Play games.";
    includes = [ "gaming-suite" ];
  };

  system = {
    description = "System administration and diagnostics.";
    includes = [
      "system-utils"
      "net-utils"
      "hardening"
    ];
  };

  server = {
    description = "Headless machine baseline.";
    capabilities = [
      "editor"
      "shell"
    ];
    includes = [
      "cli-core"
      "cli-extras"
      "nix-dev"
    ];
  };
}
