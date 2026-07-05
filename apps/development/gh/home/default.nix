{ pkgs, ... }:
{
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;

    extensions = builtins.attrValues {
      inherit (pkgs) gh-eco;
    };

    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
}
