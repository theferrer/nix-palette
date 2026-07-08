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

  spotify-player.package = pkgs.spotify-player;
  ncspot.package = pkgs.ncspot;
  television.package = pkgs.television;
}
