{
  pkgs,
  lib,
  dmsModule ? null,
  nixvimModule ? null,
  commaModule ? null,
}:
let
  dictDir = ./dictionary;
  appsDir = ../apps;

  palettePkgs = pkgs // import ../pkgs pkgs;

  dirsIn = d: builtins.attrNames (lib.filterAttrs (_: t: t == "directory") (builtins.readDir d));

  dictFiles = builtins.filter (f: lib.hasSuffix ".nix" f) (
    builtins.attrNames (builtins.readDir dictDir)
  );

  appList = lib.concatMap (
    cat:
    map (name: {
      inherit name;
      dir = appsDir + "/${cat}/${name}";
    }) (dirsIn (appsDir + "/${cat}"))
  ) (dirsIn appsDir);

  appDir = name: (lib.findFirst (a: a.name == name) (throw "no app '${name}'") appList).dir;

  importEntry =
    path:
    let
      raw = import path;
    in
    if builtins.isFunction raw then raw { pkgs = palettePkgs; } else raw;

  mergeChecked =
    what: acc: entries:
    let
      dupes = builtins.filter (n: acc ? ${n}) (builtins.attrNames entries);
    in
    if dupes == [ ] then
      acc // entries
    else
      throw "palette catalog: ${what} redefines ${lib.concatStringsSep ", " dupes}";

  dictionary = lib.foldl' (
    acc: f: mergeChecked f acc (import (dictDir + "/${f}") { pkgs = palettePkgs; })
  ) { } dictFiles;

  appEntries = lib.foldl' (
    acc: a:
    mergeChecked "apps/${a.name}" acc (
      lib.optionalAttrs (builtins.pathExists (a.dir + "/entry.nix")) {
        ${a.name} = importEntry (a.dir + "/entry.nix");
      }
    )
  ) { } appList;

  software = mergeChecked "apps/" dictionary appEntries // {

    comma = appEntries.comma // {
      homeModule =
        if commaModule == null then
          null
        else
          {
            imports = [
              commaModule
              (appDir "comma" + "/home")
            ];
          };
    };

    nvim = appEntries.nvim // {
      homeModule =
        if nixvimModule == null then
          null
        else
          {
            imports = [
              nixvimModule
              (appDir "nvim" + "/home")
            ];
          };
    };

    dms = {
      provides = [
        "bar"
        "notifications"
        "launcher"
        "screen-locker"
      ];
      description = "DankMaterialShell: bar, notifications, launcher, clipboard, lock, idle and matugen theming in one shell.";
      homeModule =
        if dmsModule == null then
          null
        else
          {
            imports = [
              dmsModule
              (appDir "dms" + "/home")
            ];
          };
    };
  };
in
{
  schemaVersion = 1;
  inherit software;
  wants = import ./wants.nix;
  looks = import ./looks.nix;
}
