{ pkgs }:
{
  # Alias of apps/browsers/google-chrome, so both names get its WebGPU flags.
  chrome = import ../../apps/browsers/google-chrome/entry.nix { inherit pkgs; };

  edge = {
    package = pkgs.microsoft-edge;
    provides = [ "browser" ];
  };

  librewolf = {
    package = pkgs.librewolf;
    provides = [ "browser" ];
  };

  qutebrowser = {
    package = pkgs.qutebrowser;
    provides = [ "browser" ];
  };

}
