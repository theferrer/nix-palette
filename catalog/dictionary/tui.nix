{ pkgs }:
{
  ranger = {
    package = pkgs.ranger;
    provides = [ "file-manager" ];
  };

  izrss = {
    package = pkgs.izrss;
  };

  mangal = {
    package = pkgs.mangal;
  };
}
