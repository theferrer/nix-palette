pkgs: {
  aseprite-mcp = pkgs.callPackage ./aseprite-mcp { };
  game-art-init = pkgs.callPackage ./game-art-init { };
  mcp-for-blender = pkgs.callPackage ./mcp-for-blender { };
  pixel-plugin = pkgs.callPackage ./pixel-plugin { };
  nosqlbooster4mongo = pkgs.callPackage ./nosqlbooster4mongo { };
  sf-pro = pkgs.callPackage ./sf-pro { };
  quickshell-fonts = pkgs.callPackage ./quickshell-fonts { };
  screenrec = pkgs.callPackage ./screenrec { };
  wl-ocr = pkgs.callPackage ./wl-ocr { };
}
