{ lib }:
let
  themes = import ../theme/themes;
  registry = import ../theme/engine/renderers;
  themeNames = lib.attrNames themes;
in
{
  testFileRenderersProduceText = {
    expr = lib.all (
      t:
      lib.all (
        r:
        let
          out = registry.files.${r} {
            name = t;
            inherit (themes.${t}) colors;
          };
        in
        lib.isString out && out != ""
      ) (lib.attrNames registry.files)
    ) themeNames;
    expected = true;
  };

  testEveryThemeRendersEverywhere = {
    expr = lib.all (
      t:
      lib.all (
        r:
        let
          out = registry.fragments.${r}.render themes.${t}.colors;
        in
        lib.isString out && out != ""
      ) (lib.attrNames registry.fragments)
    ) themeNames;
    expected = true;
  };

  testEveryThemeHasWallpaper = {
    expr = lib.all (t: builtins.pathExists themes.${t}.wallpaper) themeNames;
    expected = true;
  };
}
