{ lib, pkgs, ... }:
let
  # The palette's own derivations are not in the Home Manager pkgs; same
  # import as shared/fonts.nix.
  inherit (import ../../../../pkgs pkgs) pixel-plugin;
in
{
  # pixel-mcp reads only this file -- there is no flag or variable for it -- and
  # the plugin's /pixel-setup would write it by hand. Declared here instead,
  # pointing at the same Aseprite build the system has.
  xdg.configFile."pixel-mcp/config.json".text = builtins.toJSON {
    aseprite_path = lib.getExe pkgs.aseprite;
    timeout = 30;
    log_level = "info";
  };

  # A directory marketplace is read in place, from the store: no clone, and no
  # plugin cache to go stale when the pin moves.
  programs.claude-code.settings.extraKnownMarketplaces.pixel-plugin.source = {
    source = "directory";
    path = "${pixel-plugin}/share/claude-plugins/pixel-plugin";
  };
}
