{ pkgs }:
{
  # nixpkgs builds ghostty from source on Linux only; macOS gets upstream's
  # signed app bundle.
  package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
  provides = [ "terminal" ];
  homeModule = ./home;
}
