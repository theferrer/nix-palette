{ pkgs }:
{
  acpi = {
    package = pkgs.acpi;
  };
  bottom = {
    package = pkgs.bottom;
  };
  du-dust = {
    package = pkgs.dust;
  };
  duf = {
    package = pkgs.duf;
  };
  file = {
    package = pkgs.file;
  };
  jaq = {
    package = pkgs.jaq;
  };
  powertop = {
    package = pkgs.powertop;
  };
  freeze = {
    package = pkgs.charm-freeze;
  };
  hyfetch = {
    package = pkgs.hyfetch;
  };
  rsync = {
    package = pkgs.rsync;
  };
  just = {
    package = pkgs.just;
  };
  nix-output-monitor = {
    package = pkgs.nix-output-monitor;
  };
  glow = {
    package = pkgs.glow;
  };
  libnotify = {
    package = pkgs.libnotify;
  };
  brightnessctl = {
    package = pkgs.brightnessctl;
  };

  openssl = {
    package = pkgs.openssl;
  };
  age = {
    package = pkgs.age;
  };

  iotop = {
    package = pkgs.iotop;
  };
  gparted = {
    package = pkgs.gparted;
  };
  cpu-x = {
    package = pkgs.cpu-x;
  };
  dconf-editor = {
    package = pkgs.dconf-editor;
  };
  gpu-viewer = {
    package = pkgs.gpu-viewer;
  };
  glxinfo = {
    package = pkgs.mesa-demos;
  };
  clinfo = {
    package = pkgs.clinfo;
  };
  lshw-gtk = {
    package = pkgs.lshw;
  };
  gdu = {
    package = pkgs.gdu;
  };
  tree = {
    package = pkgs.tree;
  };
  lsof = {
    package = pkgs.lsof;
  };
  strace = {
    package = pkgs.strace;
  };
  ltrace = {
    package = pkgs.ltrace;
  };
  pciutils = {
    package = pkgs.pciutils;
  };
  usbutils = {
    package = pkgs.usbutils;
  };
  lm-sensors = {
    package = pkgs.lm_sensors;
  };
  dmidecode = {
    package = pkgs.dmidecode;
  };
  hwinfo = {
    package = pkgs.hwinfo;
  };
  smartmontools = {
    package = pkgs.smartmontools;
  };
  inxi = {
    package = pkgs.inxi;
  };
  procs = {
    package = pkgs.procs;
  };
  zenith = {
    package = pkgs.zenith;
  };
  inotify-tools = {
    package = pkgs.inotify-tools;
  };

  tokei = {
    package = pkgs.tokei;
  };
  hyperfine = {
    package = pkgs.hyperfine;
  };
  ouch = {
    package = pkgs.ouch;
  };
  rclone = {
    package = pkgs.rclone;
  };
  ncdu = {
    package = pkgs.ncdu;
  };
  dua = {
    package = pkgs.dua;
  };
  mtr = {
    package = pkgs.mtr;
  };
  bandwhich = {
    package = pkgs.bandwhich;
  };
  iperf3 = {
    package = pkgs.iperf3;
  };
  traceroute = {
    package = pkgs.traceroute;
  };
  whois = {
    package = pkgs.whois;
  };
  socat = {
    package = pkgs.socat;
  };
  netcat = {
    package = pkgs.netcat;
  };
  sysstat = {
    package = pkgs.sysstat;
  };
  lazydocker = {
    package = pkgs.lazydocker;
  };
  ctop = {
    package = pkgs.ctop;
  };
  xdg-ninja = {
    package = pkgs.xdg-ninja;
  };

  swaylock = {
    package = pkgs.swaylock;
    provides = [ "screen-locker" ];
  };
  gtklock = {
    package = pkgs.gtklock;
    provides = [ "screen-locker" ];
  };

  wf-recorder = {
    package = pkgs.wf-recorder;
  };

  xdg-utils = {
    package = pkgs.xdg-utils;
  };
  trash-cli = {
    package = pkgs.trash-cli;
  };
  xdg-desktop-portal-hyprland = {
    package = pkgs.xdg-desktop-portal-hyprland;
  };
  xdg-desktop-portal-gtk = {
    package = pkgs.xdg-desktop-portal-gtk;
  };
  polkit-kde-agent = {
    package = pkgs.kdePackages.polkit-kde-agent-1;
  };

  appimage-run = {
    package = pkgs.appimage-run;
  };
  mission-center = {
    package = pkgs.mission-center;
  };
  resources = {
    package = pkgs.resources;
  };
  gnome-system-monitor = {
    package = pkgs.gnome-system-monitor;
  };
  gnome-usage = {
    package = pkgs.gnome-usage;
  };
  gnome-disk-utility = {
    package = pkgs.gnome-disk-utility;
  };
  corectrl = {
    package = pkgs.corectrl;
  };
  ntfs3g.package = pkgs.ntfs3g;
  lm_sensors.package = pkgs.lm_sensors;
  lshw.package = pkgs.lshw;
  fuse.package = pkgs.fuse;
  xdg-user-dirs.package = pkgs.xdg-user-dirs;
  cpupower.package = pkgs.linuxPackages.cpupower;
  undervolt.package = pkgs.undervolt;
  tpm2-pkcs11.package = pkgs.tpm2-pkcs11;
  unar.package = pkgs.unar;
  seahorse.package = pkgs.seahorse;
  exiftool.package = pkgs.exiftool;
  poppler-utils.package = pkgs.poppler-utils;
  fontpreview.package = pkgs.fontpreview;
  upower.package = pkgs.upower;

  # Modern CLI replacements and helpers
  sd.package = pkgs.sd;
  entr.package = pkgs.entr;
  watchexec.package = pkgs.watchexec;
  mprocs.package = pkgs.mprocs;
  pueue.package = pkgs.pueue;
  navi.package = pkgs.navi;
  broot.package = pkgs.broot;
  fx.package = pkgs.fx;
  gron.package = pkgs.gron;
  jc.package = pkgs.jc;
  fq.package = pkgs.fq;

  # Docs and rendering
  pandoc.package = pkgs.pandoc;
  graphviz.package = pkgs.graphviz;
  presenterm.package = pkgs.presenterm;

  # Transfer and sync
  croc.package = pkgs.croc;
  magic-wormhole.package = pkgs.magic-wormhole;
  termscp.package = pkgs.termscp;

  # Recording and demos
  asciinema.package = pkgs.asciinema;
  vhs.package = pkgs.vhs;
  onefetch.package = pkgs.onefetch;

  # Monitoring and inspection
  glances.package = pkgs.glances;
  trippy.package = pkgs.trippy;
  lnav.package = pkgs.lnav;
  lazyjournal.package = pkgs.lazyjournal;
  angle-grinder.package = pkgs.angle-grinder;

  # Dotfiles and maintenance
  chezmoi.package = pkgs.chezmoi;
  topgrade.package = pkgs.topgrade;

  # Productivity and misc
  kalker.package = pkgs.kalker;
  buku.package = pkgs.buku;
  timewarrior.package = pkgs.timewarrior;
  ttyd.package = pkgs.ttyd;
  gpg-tui.package = pkgs.gpg-tui;
  dooit.package = pkgs.dooit;
}
