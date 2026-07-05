{
  dmsModule ? null,
  nixvimModule ? null,
  commaModule ? null,
}:
{ pkgs, lib, ... }:
let
  appsDir = ../apps;
  dirsIn = d: builtins.attrNames (lib.filterAttrs (_: t: t == "directory") (builtins.readDir d));

  appGlue = builtins.filter builtins.pathExists (
    lib.concatMap (cat: map (n: appsDir + "/${cat}/${n}/nixos.nix") (dirsIn (appsDir + "/${cat}"))) (
      dirsIn appsDir
    )
  );
in
{
  imports = appGlue ++ [
    ../shared/console.nix
    ../shared/fonts.nix
    ../shared/portals.nix
  ];

  canvas.catalog = import ../catalog {
    inherit
      pkgs
      lib
      dmsModule
      nixvimModule
      commaModule
      ;
  };
}
