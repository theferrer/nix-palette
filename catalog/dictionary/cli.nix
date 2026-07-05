{ pkgs }:
{
  curl = {
    package = pkgs.curl;
  };
  wget = {
    package = pkgs.wget;
  };
  ripgrep = {
    package = pkgs.ripgrep;
  };
  fd = {
    package = pkgs.fd;
  };
  jq = {
    package = pkgs.jq;
  };
  fastfetch = {
    package = pkgs.fastfetch;
  };
  htop = {
    package = pkgs.htop;
  };
  tealdeer = {
    package = pkgs.tealdeer;
  };
}
