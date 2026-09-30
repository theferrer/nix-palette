{ pkgs }:
{
  # Registered as a marketplace for every Claude Code session but enabled per
  # project (`game-art-init` writes the enabledPlugins entry), so its MCP
  # server and skills only load where the art work happens.
  package = pkgs.pixel-plugin;
  description = "Claude Code plugin for Aseprite pixel art (skills, commands and pixel-mcp), NixOS-patched.";
  homeModule = ./home;
}
