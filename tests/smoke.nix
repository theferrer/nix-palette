{
  pkgs,
  lib,
  canvas,
  home-manager,
  dmsModule,
  nixvimModule,
  commaModule,
}:
let
  eval = import (pkgs.path + "/nixos/lib/eval-config.nix") {
    system = pkgs.stdenv.hostPlatform.system;
    modules = [
      canvas.nixosModules.default
      (import ../modules/nixos.nix { inherit dmsModule nixvimModule commaModule; })
      home-manager.nixosModules.home-manager
      {
        nixpkgs.config.allowUnfree = true;
        canvas = {
          machine = {
            primaryUser = "tester";
            formFactor = "laptop";
          };
          hardware.monitors = [
            {
              name = "eDP-1";
              resolution = "2560x1600";
              refreshRate = 240;
              primary = true;
            }
          ];
          wants = [
            "desktop"
            "development"
            "gaming"
            "laptop"
            "system"
          ];
          look = "neon";
          extra = [
            "kdeconnect"
            "syncthing"
          ];

          secrets = {
            "atuin/key" = "/run/secrets/atuin/key";
            "syncthing/key" = "/run/secrets/syncthing/key";
            "syncthing/cert" = "/run/secrets/syncthing/cert";
          };
          integrations.home-manager.enable = true;
        };
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.tester = {
            imports = [
              ../theme/engine
              ../shared/xdg
            ];
            home = {
              username = "tester";
              homeDirectory = "/home/tester";
              stateVersion = "25.05";
            };
          };
        };
        users.users.tester.isNormalUser = true;
        boot.loader.grub.enable = false;
        fileSystems."/" = {
          device = "none";
          fsType = "tmpfs";
        };
        system.stateVersion = "25.05";
      }
    ];
  };
  cfg = eval.config;
  hm = cfg.home-manager.users.tester;
  failedMessages = c: map (a: a.message) (builtins.filter (a: !a.assertion) c.assertions);

  themes = import ../theme/themes;
  inherit (cfg.canvas) resolved;
  inherit (resolved) capabilityMap;
  active = name: resolved.software ? ${name};
  appFor = cap: capabilityMap.${cap} or null;

  exeFor =
    cap:
    let
      pkg = resolved.software.${appFor cap}.package or null;
    in
    if pkg == null then appFor cap else builtins.unsafeDiscardStringContext (lib.getExe pkg);

  implies = name: consequence: (!active name) || consequence;
in
{
  testSmokeAssertionsPass = {
    expr = failedMessages cfg;
    expected = [ ];
  };

  testSmokeProtocolDerivedFromDesktop = {
    expr =
      appFor "desktop" != null
      && resolved.sessionProtocol == resolved.software.${appFor "desktop"}.sessionProtocol
      && resolved.graphical;
    expected = true;
  };

  testSmokeStyleFollowsLook = {
    expr = cfg.canvas.style.name == cfg.canvas.catalog.looks.neon.style;
    expected = true;
  };

  testSmokeResolvedPackagesInstalled = {
    expr = lib.all (p: lib.elem p cfg.environment.systemPackages) resolved.packages;
    expected = true;
  };

  testSmokeSystemGlueFollowsActiveSet = {
    expr = {
      greetd = implies "greetd" (
        cfg.services.greetd.enable
        && lib.hasInfix "--sessions" cfg.services.greetd.settings.default_session.command
      );
      hyprlandSession = implies "hyprland" (cfg.programs.hyprland.enable && cfg.programs.uwsm.enable);
      steam = implies "steam" cfg.programs.steam.enable;
      podman = implies "podman" cfg.virtualisation.podman.enable;
      kdeconnectFirewall = implies "kdeconnect" (
        lib.any (r: r.from == 1714 && r.to == 1764) cfg.networking.firewall.allowedTCPPortRanges
      );
      gnupgDbus = implies "gnupg" (cfg.services.dbus.packages != [ ]);
    };
    expected = {
      greetd = true;
      hyprlandSession = true;
      steam = true;
      podman = true;
      kdeconnectFirewall = true;
      gnupgDbus = true;
    };
  };

  testSmokeInjectionFollowsCapabilityMap = {
    expr = lib.all (cap: hm.programs.${appFor cap}.enable or false) (
      lib.filter (cap: appFor cap != null && hm.programs ? ${appFor cap}) [
        "terminal"
        "shell"
        "browser"
        "editor"
        "pdf-viewer"
      ]
    );
    expected = true;
  };

  testSmokeBarShellEnabled = {
    expr = (appFor "bar") != "dms" || hm.programs.dank-material-shell.enable;
    expected = true;
  };

  testSmokeHyprlandContractReached = {
    expr =
      let
        settings = hm.wayland.windowManager.hyprland.settings;
        m = lib.head cfg.canvas.hardware.monitors;
        monitorPrefix = "${m.name},${m.resolution}@${toString m.refreshRate}";
      in
      implies "hyprland" (
        lib.any (line: lib.hasPrefix monitorPrefix line) settings.monitor
        && lib.any (b: lib.hasInfix (exeFor "terminal") b) settings.bind
        && lib.any (src: lib.hasSuffix "hypr/dms/colors.conf" src) settings.source
        && settings.input.kb_layout == cfg.canvas.hardware.keyboard.layout
        && (cfg.canvas.machine.formFactor != "laptop" || hm.systemd.user.services ? hyprland-power-monitor)
      );
    expected = true;
  };

  testSmokeEditorInjected = {
    expr = implies "nvim" hm.programs.nixvim.enable;
    expected = true;
  };

  testSmokeSecretsReachConsumers = {
    expr = {
      atuinKey = hm.programs.atuin.settings.key_path or null;
      syncthingKey = hm.services.syncthing.key;
      syncthingCert = hm.services.syncthing.cert;
      provenance = resolved.secretsProvenance;
    };
    expected = {
      atuinKey = "/run/secrets/atuin/key";
      syncthingKey = "/run/secrets/syncthing/key";
      syncthingCert = "/run/secrets/syncthing/cert";
      provenance = {
        "atuin/key" = [ "optional-for:atuin" ];
        "syncthing/key" = [ "optional-for:syncthing" ];
        "syncthing/cert" = [ "optional-for:syncthing" ];
      };
    };
  };

  testSmokeGuiIdentityFollowsTheme = {
    expr =
      let
        gui = themes.${cfg.canvas.style.name}.gui;
      in
      {
        cursor = hm.home.pointerCursor.name == gui.cursor.name;
        icons = hm.gtk.iconTheme.name == gui.icons.name;
        font = hm.gtk.font.name == gui.font.name;
        batTheme = !active "bat" || hm.programs.bat.config.theme == cfg.canvas.style.name;
      };
    expected = {
      cursor = true;
      icons = true;
      font = true;
      batTheme = true;
    };
  };

  testSmokeMimeFollowsCapabilityMap = {
    expr = {
      browser = appFor "browser" == null || hm.xdg.mimeApps.defaultApplications."text/html" != [ ];
      pdf = appFor "pdf-viewer" == null || hm.xdg.mimeApps.defaultApplications."application/pdf" != [ ];
    };
    expected = {
      browser = true;
      pdf = true;
    };
  };

  testSmokeThemeEngine = {
    expr =
      let
        fragmentFor =
          app: file: (hm.xdg.dataFile ? "canvas-themes/${cfg.canvas.style.name}/${file}") == active app;
      in
      {
        themeSet = lib.any (p: (p.name or "") == "theme-set") hm.home.packages;
        kitty = fragmentFor "kitty" "kitty.conf";
        hyprland = fragmentFor "hyprland" "hyprland.conf";
      };
    expected = {
      themeSet = true;
      kitty = true;
      hyprland = true;
    };
  };

  testSmokeGraphicalPlumbing = {
    expr =
      !resolved.graphical
      || (
        cfg.fonts.packages != [ ]
        && cfg.xdg.portal.enable
        && cfg.services.displayManager.sessionPackages != [ ]
      );
    expected = true;
  };
}
