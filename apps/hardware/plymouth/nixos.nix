{
  config,
  lib,
  canvasLib,
  pkgs,
  ...
}:
let
  themes = import ../../../theme/themes;
  styleName = config.canvas.style.name or null;
  themeName =
    if styleName != null && themes ? ${styleName} then styleName else lib.head (lib.attrNames themes);
  inherit (themes.${themeName}) colors;

  # Plymouth's script API takes 0-1 floats per channel.
  channel = hex: i: lib.fromHexString (builtins.substring i 2 hex);
  floats =
    hex:
    lib.concatMapStringsSep ", " (i: toString (channel hex i / 255.0)) [
      1
      3
      5
    ];

  themePkg =
    pkgs.runCommand "plymouth-theme-${themeName}"
      {
        nativeBuildInputs = [ pkgs.imagemagick ];
      }
      ''
        dir=$out/share/plymouth/themes/${themeName}
        mkdir -p $dir

        magick -size 400x10 xc:"${colors.base0D}" $dir/progress_bar.png

        cat > $dir/${themeName}.plymouth <<EOF
        [Plymouth Theme]
        Name=${themeName}
        Description=Boot splash in the ${themeName} palette
        ModuleName=script

        [script]
        ImageDir=$dir
        ScriptFile=$dir/theme.script
        EOF

        cat > $dir/theme.script <<'EOF'
        Window.SetBackgroundTopColor(${floats colors.base00});
        Window.SetBackgroundBottomColor(${floats colors.base01});

        progress_bar.image = Image("progress_bar.png");
        progress_bar.sprite = Sprite(progress_bar.image);
        progress_bar.sprite.SetPosition(
          Window.GetX() + Window.GetWidth() / 2 - progress_bar.image.GetWidth() / 2,
          Window.GetY() + Window.GetHeight() * 0.75,
          0);

        fun progress_callback(duration, progress) {
          progress_bar.sprite.SetOpacity(progress);
        }

        Plymouth.SetBootProgressFunction(progress_callback);
        EOF
      '';
in
lib.mkIf (canvasLib.isActive config "plymouth") {
  boot.plymouth = {
    enable = true;
    theme = themeName;
    themePackages = [ themePkg ];
  };
}
