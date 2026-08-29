{
  config,
  lib,
  osConfig ? null,
  ...
}:
let
  conf = if osConfig != null then osConfig else config;
  isLaptop = (conf.canvas.machine.formFactor or "desktop") == "laptop";
in
{
  programs.dank-material-shell = {
    enable = true;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    settings = {

      cornerRadius = 12;

      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          position = 0;
          screenPreferences = [ "all" ];
          showOnLastDisplay = true;

          # Barra encajada arriba: sin gap con los bordes (spacing=0), sin
          # reserva extra de zona exclusiva (bottomGap=0) y esquinas rectas.
          # Así queda a ras del borde superior y se aprovechan esos píxeles.
          bottomGap = 0;
          squareCorners = true;
          spacing = 0;
          innerPadding = 6;

          autoHide = true;
          autoHideDelay = 250;
          openOnOverview = false;
          visible = true;
          maximizeDetection = true;

          leftWidgets = [
            "launcherButton"
            "workspaceSwitcher"
            "focusedWindow"
          ];
          centerWidgets = [
            "music"
            "clock"
            "weather"
          ];
          rightWidgets = [
            "systemTray"
            "clipboard"
            "cpuUsage"
            "memUsage"
            "notificationButton"
          ]
          ++ lib.optional isLaptop "battery"
          ++ [ "controlCenterButton" ];

          # transparency is really the background opacity (withAlpha on the
          # matugen surface); < 1 lets the wallpaper through for some depth.
          transparency = 0.85;
          widgetTransparency = 0.9;
          noBackground = false;
          borderEnabled = false;
          widgetOutlineEnabled = true;
          widgetOutlineColor = "primary";
          widgetOutlineOpacity = 0.35;
          widgetOutlineThickness = 1;
          gothCornersEnabled = false;
          fontScale = 1;
          popupGapsAuto = true;
          popupGapsManual = 4;
        }
      ];

      showDock = false;
      dockAutoHide = true;
      dockBottomGap = 0;

      spotlightCloseNiriOverview = true;
      niriOverviewOverlayEnabled = true;

      matugenScheme = "scheme-expressive";
      widgetColorMode = "colorful";
      gtkThemingEnabled = true;
      qtThemingEnabled = true;
      runUserMatugenTemplates = true;
      matugenTemplateKitty = true;
      terminalsAlwaysDark = true;

      # Idle timeouts, in seconds. Every one of these defaults to 0 in DMS,
      # which means "never": as shipped this machine never blanks the panel,
      # never locks and never idle-suspends -- only the lid and upower's 5%
      # cutoff ever put it to sleep. On an OLED that is both the largest
      # avoidable drain and a burn-in risk. On AC only the panel blanks;
      # suspending a plugged-in machine out from under a long build would be
      # worse than the power it saves.
      acMonitorTimeout = 900;
      acLockTimeout = 0;
      acSuspendTimeout = 0;
      batteryMonitorTimeout = 120;
      batteryLockTimeout = 300;
      batterySuspendTimeout = 900;

      use24HourClock = true;
      showSeconds = false;

      fontFamily = "Inter Variable";
      monoFontFamily = "JetBrainsMono Nerd Font";
    };

    session = { };
  };

  home.file.".config/DankMaterialShell/wallpaper.jpg".source =
    config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/theme/current/wallpaper";
}
