{ pkgs, ... }:
let
  # The palette's own derivations are not in the Home Manager pkgs; same
  # import as shared/fonts.nix.
  inherit (import ../../../../pkgs pkgs) codex-imagegen;
in
{
  # Read in place from the store, like pixel-plugin. The name is the one
  # upstream's marketplace.json declares, so the plugin id stays
  # imagegen@imagegen-marketplace.
  programs.claude-code.settings.extraKnownMarketplaces.imagegen-marketplace.source = {
    source = "directory";
    path = "${codex-imagegen}/share/claude-plugins/codex-imagegen";
  };
}
