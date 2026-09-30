{ pkgs }:
{
  # Registered as a marketplace for every Claude Code session but enabled only
  # per project, and only on request (`game-art-init imagegen`): its skill
  # generates images for almost any build task without asking, through
  # `codex exec --sandbox danger-full-access`, on the ChatGPT plan's quota.
  package = pkgs.codex-imagegen;
  description = "Claude Code plugin generating and editing images through Codex CLI's gpt-image (ChatGPT plan).";
  homeModule = ./home;
}
