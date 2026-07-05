{
  imports = [ ./config ];

  programs.nixvim = {
    enable = true;
    nixpkgs.useGlobalPackages = true;
  };
}
