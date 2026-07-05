{ pkgs, ... }:
let
  switch-keyboard-layout = pkgs.writeShellScriptBin "switch-keyboard-layout" ''
    # Switch keyboard layout for all keyboards in Hyprland
    keyboards=$(hyprctl devices -j | ${pkgs.jq}/bin/jq -r '.keyboards[].name')

    while IFS= read -r keyboard; do
      if [ -n "$keyboard" ]; then
        echo "Switching layout for: $keyboard"
        hyprctl switchxkblayout "$keyboard" next
      fi
    done <<< "$keyboards"

    echo -e "\nCurrent keyboard layouts:"
    hyprctl devices | grep -A2 "Keyboard at" | grep -E "Keyboard at|active keymap"
  '';
in
{
  home.packages = [ switch-keyboard-layout ];

  wayland.windowManager.hyprland.settings.bind = [
    "SUPER, K, exec, switch-keyboard-layout"
  ];
}
