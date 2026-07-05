{
  imports = [ ./extensions.nix ];

  programs.firefox = {
    enable = true;

    # Pin the legacy profile location; the XDG default would strand an existing
    # ~/.mozilla/firefox profile until it is moved by hand.
    configPath = ".mozilla/firefox";

    profiles.default = {
      isDefault = true;
      id = 0;
    };
  };
}
