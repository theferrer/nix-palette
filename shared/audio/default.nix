_: {
  xdg.configFile."pipewire/pipewire.conf.d/99-input-denoising.conf".text = builtins.toJSON {
    "context.modules" = [
      {
        "name" = "libpipewire-module-filter-chain";
        # nofail: a broken filter must not abort the whole pipewire context.
        "flags" = [ "nofail" ];
        "args" = {
          "node.description" = "Noise Canceling source";
          "media.name" = "Noise Canceling source";
          "filter.graph" = {
            "nodes" = [
              {
                "type" = "ladspa";
                "name" = "rnnoise";
                # Resolved by name against pipewire's LADSPA_PATH; rnnoise-plugin
                # is put there by shared/audio/nixos.nix (extraLadspaPackages).
                "plugin" = "librnnoise_ladspa";
                "label" = "noise_suppressor_stereo";
                "control" = {
                  "VAD Threshold (%)" = 30.0;
                };
              }
            ];
          };
          "audio.position" = [
            "FL"
            "FR"
          ];
          "capture.props" = {
            "node.name" = "effect_input.rnnoise";
            "node.passive" = true;
          };
          "playback.props" = {
            "node.name" = "effect_output.rnnoise";
            "media.class" = "Audio/Source";
          };
        };
      }
    ];
  };
}
