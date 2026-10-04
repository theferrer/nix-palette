{
  dmsModule ? null,
  nixvimModule ? null,
  commaModule ? null,
}:
{ pkgs, lib, ... }:
let
  appsDir = ../apps;
  dirsIn = d: builtins.attrNames (lib.filterAttrs (_: t: t == "directory") (builtins.readDir d));

  # Same discovery as nixos.nix, for the darwin side of an app's system glue.
  appGlue = builtins.filter builtins.pathExists (
    lib.concatMap (cat: map (n: appsDir + "/${cat}/${n}/darwin.nix") (dirsIn (appsDir + "/${cat}"))) (
      dirsIn appsDir
    )
  );
in
{
  imports = appGlue ++ [
    ../shared/fonts-darwin.nix
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
