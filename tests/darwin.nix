# Evaluates a whole aarch64-darwin system from any host: nothing is built,
# but every module and every package's derivation has to instantiate, which
# is where Linux-only assumptions surface.
{
  lib,
  canvas,
  home-manager,
  nix-darwin,
  nixvimModule,
  commaModule,
}:
let
  eval = nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      canvas.darwinModules.default
      (import ../modules/darwin.nix { inherit nixvimModule commaModule; })
      home-manager.darwinModules.home-manager
      {
        nixpkgs.config.allowUnfree = true;
        system.stateVersion = 6;
        canvas = {
          machine = {
            primaryUser = "tester";
            formFactor = "laptop";
            graphical = true;
          };
          wants = [
            "mac-desktop"
            "development"
            "system"
          ];
          look = "neon-mac";
          extra = [
            "1password"
            "ghostty"
          ];
          integrations.home-manager.enable = true;
        };
        users.users.tester.home = "/Users/tester";
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.tester = {
            imports = [ ../theme/engine ];
            home.stateVersion = "25.05";
          };
        };
      }
    ];
  };
  cfg = eval.config;
  hm = cfg.home-manager.users.tester;
  inherit (cfg.canvas) resolved;
  active = name: resolved.software ? ${name};
  failedMessages = c: map (a: a.message) (builtins.filter (a: !a.assertion) c.assertions);
in
{
  testDarwinAssertionsPass = {
    expr = failedMessages cfg ++ failedMessages hm;
    expected = [ ];
  };

  testDarwinInstantiates = {
    expr = lib.isString cfg.system.build.toplevel.drvPath;
    expected = true;
  };

  testDarwinLookResolved = {
    expr = {
      inherit (resolved.capabilityMap)
        desktop
        terminal
        shell
        editor
        ;
      inherit (resolved) graphical;
    };
    expected = {
      desktop = "aerospace";
      terminal = "kitty";
      shell = "fish";
      editor = "nvim";
      graphical = true;
    };
  };

  testDarwinLinuxOnlyDropped = {
    expr = {
      hyprland = (resolved.software.hyprland or { }).package or null;
      obs = (resolved.software.obs-studio or { }).package or null;
    };
    expected = {
      hyprland = null;
      obs = null;
    };
  };

  testDarwinGlueFollowsActiveSet = {
    expr = {
      aerospace = hm.programs.aerospace.enable && hm.programs.aerospace.launchd.enable;
      borders = cfg.services.jankyborders.enable;
      fishLogin = cfg.programs.fish.enable && cfg.users.users.tester.shell.pname or null == "fish";
      onePassword = lib.elem "1password" (map (c: c.name or c) cfg.homebrew.casks);
      ghostty = lib.getName hm.programs.ghostty.package;
    };
    expected = {
      aerospace = true;
      borders = true;
      fishLogin = true;
      onePassword = active "1password";
      ghostty = "ghostty-bin";
    };
  };

  testDarwinKittyFollowsThemeEngine = {
    expr = lib.hasInfix "theme/current/kitty.conf" hm.programs.kitty.extraConfig;
    expected = true;
  };
}
