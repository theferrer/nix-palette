{ pkgs }:
{
  teams = {
    package = pkgs.teams-for-linux;
  };

  whatsapp = {
    package = pkgs.karere;
  };

  element = {
    package = pkgs.element-desktop;
  };

  zulip = {
    package = pkgs.zulip;
  };

  teamspeak = {
    package = pkgs.teamspeak6-client;
  };

  zoom = {
    package = pkgs.zoom-us;
  };
}
