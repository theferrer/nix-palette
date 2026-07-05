{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
let
  conf = if osConfig != null then osConfig else config;
  graphical = conf.canvas.resolved.graphical or false;
in
{
  services.gpg-agent = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableNushellIntegration = config.programs.nushell.enable;

    pinentry.package = if graphical then pkgs.pinentry-gnome3 else pkgs.pinentry-curses;
    enableScDaemon = true;
    enableSshSupport = true;
    defaultCacheTtl = 1209600;
    defaultCacheTtlSsh = 1209600;
    maxCacheTtl = 1209600;
    maxCacheTtlSsh = 1209600;
    extraConfig = "allow-preset-passphrase";
  };

  systemd.user.services.gpg-agent.Unit.RefuseManualStart = lib.mkForce false;

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    settings = {
      keyserver = "keys.openpgp.org";

      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      charset = "utf-8";
      fixed-list-mode = "";
      no-comments = "";
      no-emit-version = "";
      no-greeting = "";
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      with-fingerprint = "";
      require-cross-certification = "";
      no-symkey-cache = "";
      use-agent = "";
      armor = "";
      throw-keyids = "";
    };
  };
}
