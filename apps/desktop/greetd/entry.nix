{ pkgs }:
{
  package = pkgs.greetd;
  provides = [ "login-manager" ];
}
