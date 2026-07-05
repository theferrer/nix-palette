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

      cornerRadius = 0;

      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          position = 0;
          screenPreferences = [ "all" ];
          showOnLastDisplay = true;

          bottomGap = 0;
          squareCorners = true;
          spacing = 0;
          innerPadding = 0;

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

          transparency = 1;
          widgetTransparency = 1;
          noBackground = false;
          borderEnabled = false;
          widgetOutlineEnabled = false;
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

      use24HourClock = true;
      showSeconds = false;
    };

    session = { };
  };

  home.file.".config/DankMaterialShell/wallpaper.jpg".source =
    config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/theme/current/wallpaper";
}
