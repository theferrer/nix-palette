{
  wayland.windowManager.hyprland.settings.animations = {
    enabled = true;

    bezier = [
      "smoothOut, 0.36, 0, 0.66, -0.56"
      "smoothIn, 0.25, 1, 0.5, 1"
      "overshot, 0.4, 0.8, 0.2, 1.2"
      "softAcDecel, 0.26, 0.26, 0.15, 1"
      "md2, 0.4, 0, 0.2, 1"
    ];

    animation = [

      "windowsIn, 1, 4, md2, popin 85%"
      "windowsOut, 1, 4, smoothOut, popin 85%"
      "windowsMove, 1, 4, softAcDecel, slide"

      "layersIn, 1, 3, md2, slide"
      "layersOut, 1, 3, smoothOut, slide"

      "fadeIn, 1, 4, smoothIn"
      "fadeOut, 1, 4, smoothOut"
      "fadeSwitch, 1, 4, softAcDecel"
      "fadeShadow, 1, 4, softAcDecel"
      "fadeDim, 1, 4, softAcDecel"
      "fadeLayersIn, 1, 3, smoothIn"
      "fadeLayersOut, 1, 3, smoothOut"

      "border, 1, 10, softAcDecel"
      "borderangle, 1, 100, softAcDecel, loop"

      "workspaces, 1, 4, overshot, slide"
      "specialWorkspace, 1, 4, md2, slidevert"

      "monitorAdded, 1, 3, smoothIn"
    ];
  };
}
