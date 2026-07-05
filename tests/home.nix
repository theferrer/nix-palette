{
  pkgs,
  lib,
  canvas,
  home-manager,
}:
let
  hm = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      canvas.homeModules.default
      (import ../modules/home.nix { })
      ../theme/engine
      ../apps/terminals/kitty/home
      {
        home = {
          username = "tester";
          homeDirectory = "/home/tester";
          stateVersion = "25.05";
        };
        canvas = {
          machine = {
            primaryUser = "tester";
            formFactor = "desktop";
          };
          wants = [
            "desktop"
            "development"
          ];
          look = "neon";
        };
      }
    ];
  };
  cfg = hm.config;
  failed = map (a: a.message) (builtins.filter (a: !a.assertion) cfg.assertions);
  active = name: cfg.canvas.resolved.software or { } ? ${name};
in
{
  testHomeAssertionsPass = {
    expr = failed;
    expected = [ ];
  };

  testThemeFragmentsFollowActiveSet = {
    expr =
      let
        style = cfg.canvas.style.name;
        fragmentFor = app: file: (cfg.xdg.dataFile ? "canvas-themes/${style}/${file}") == active app;
      in
      {
        kitty = fragmentFor "kitty" "kitty.conf";
        hyprland = fragmentFor "hyprland" "hyprland.conf";
        wallpaper = cfg.xdg.dataFile ? "canvas-themes/${style}/wallpaper";
      };
    expected = {
      kitty = true;
      hyprland = true;
      wallpaper = true;
    };
  };

  testKittyIncludesMatugenTheme = {
    expr = !active "kitty" || lib.hasInfix "kitty/dank-theme.conf" cfg.programs.kitty.extraConfig;
    expected = true;
  };

  testThemeSetInstalled = {
    expr = lib.any (p: (p.name or "") == "theme-set") cfg.home.packages;
    expected = true;
  };
}
