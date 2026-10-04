{
  config,
  lib,
  osConfig ? null,
  ...
}:
let
  conf = if osConfig != null then osConfig else config;
  inherit (conf.canvas) resolved;
  appFor = cap: resolved.capabilityMap.${cap} or null;

  exeFor =
    cap:
    let
      app = appFor cap;
      package = if app == null then null else resolved.software.${app}.package or null;
    in
    if package == null then null else lib.getExe package;

  terminal = exeFor "terminal";
  inTerminal = cmd: "exec-and-forget ${terminal} -e ${cmd}";

  # Browsers on macOS are app bundles, and `open -a` is what focuses an
  # already-running one instead of spawning a second instance.
  browserApps = {
    chrome = "Google Chrome";
    google-chrome = "Google Chrome";
    vivaldi = "Vivaldi";
    firefox = "Firefox";
  };
  browser = browserApps.${appFor "browser"} or null;

  # Hyprland's SUPER, moved off the keys macOS already owns: cmd is every
  # app's shortcut layer, and plain option is how a Spanish layout types
  # @ # | [ ] { } -- binding alt-2 would cost the at sign. ctrl-alt is free.
  mod = "ctrl-alt";

  # The Hyprland move/resize submaps use j/l/i/k as left/right/up/down.
  directions = {
    left = [
      "left"
      "j"
    ];
    right = [
      "right"
      "l"
    ];
    up = [
      "up"
      "i"
    ];
    down = [
      "down"
      "k"
    ];
  };
  forDirections = f: lib.concatMapAttrs (dir: keys: lib.genAttrs keys (_: f dir)) directions;

  workspaces = map toString (lib.range 1 9) ++ [ "0" ];
  wsName = k: if k == "0" then "10" else k;

  backToMain = {
    esc = "mode main";
    enter = "mode main";
  };
in
{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;

    settings = {
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      automatically-unhide-macos-hidden-apps = true;

      # Hyprland's dwindle with 8px gaps.
      accordion-padding = 30;
      gaps = {
        inner = {
          horizontal = 8;
          vertical = 8;
        };
        outer = {
          left = 8;
          right = 8;
          top = 8;
          bottom = 8;
        };
      };

      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      # Dialog-shaped apps float instead of claiming half the screen.
      on-window-detected =
        map
          (id: {
            "if".app-id = id;
            run = [ "layout floating" ];
          })
          [
            "com.apple.systempreferences"
            "com.apple.ActivityMonitor"
            "com.apple.calculator"
            "com.1password.1password"
          ];

      mode = {
        main.binding = {
          "${mod}-enter" = "exec-and-forget ${terminal} --single-instance --directory ~";
          "${mod}-c" = inTerminal "nvim";
          "${mod}-e" = "exec-and-forget open ~";

          "${mod}-q" = "close";
          "${mod}-f" = "fullscreen";
          "${mod}-space" = "layout floating tiling";
          "${mod}-s" = "layout tiles horizontal vertical";
          # Hyprland groups -> accordion, the stacked layout.
          "${mod}-g" = "layout accordion tiles";
          "${mod}-tab" = "workspace-back-and-forth";

          # Hyprland's special workspace has no AeroSpace equivalent; a named
          # workspace on the same key is the closest thing.
          "${mod}-backtick" = "workspace S";
          "${mod}-shift-backtick" = "move-node-to-workspace S";

          "${mod}-shift-g" = inTerminal "lazygit";
          "${mod}-shift-d" = inTerminal "lazydocker";
          "${mod}-shift-b" = inTerminal "btop";
          "${mod}-shift-e" = inTerminal "yazi";

          # Print -> region to the clipboard; mod-shift-s -> region to a file.
          "${mod}-p" = "exec-and-forget screencapture -ic";
          "${mod}-shift-s" = "exec-and-forget screencapture -i ~/Pictures/screenshot-$(date +%s).png";
          "${mod}-shift-w" = "exec-and-forget screencapture -iW ~/Pictures/screenshot-$(date +%s).png";

          "${mod}-l" = "exec-and-forget pmset displaysleepnow";
          "${mod}-shift-r" = "reload-config";

          "${mod}-m" = "mode move";
          "${mod}-r" = "mode resize";
        }
        // lib.optionalAttrs (browser != null) {
          "${mod}-b" = "exec-and-forget open -a '${browser}'";
        }
        # Arrows only: mod-l is the lock, as on Hyprland.
        // lib.genAttrs' [ "left" "right" "up" "down" ] (
          dir: lib.nameValuePair "${mod}-${dir}" "focus ${dir}"
        )
        // lib.listToAttrs (
          lib.concatMap (k: [
            (lib.nameValuePair "${mod}-${k}" "workspace ${wsName k}")
            (lib.nameValuePair "${mod}-shift-${k}" "move-node-to-workspace ${wsName k}")
          ]) workspaces
        );

        move.binding = forDirections (dir: "move ${dir}") // backToMain;

        resize.binding =
          lib.genAttrs [ "left" "h" ] (_: "resize width -50")
          // lib.genAttrs [ "right" "j" ] (_: "resize width +50")
          // lib.genAttrs [ "up" "i" ] (_: "resize height -50")
          // lib.genAttrs [ "down" "k" ] (_: "resize height +50")
          // backToMain;
      };
    };
  };
}
