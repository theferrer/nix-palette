{ pkgs }:
{
  amule = {
    package = pkgs.amule;
  };
  google-cloud-sdk = {
    # kubectl talks to GKE through gke-gcloud-auth-plugin, a separate SDK
    # component gcloud no longer bundles; without it kubectl auth fails.
    package = pkgs.google-cloud-sdk.withExtraComponents [
      pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
    ];
  };
  nmap = {
    package = pkgs.nmap;
  };
  lens = {
    package = pkgs.lens;
  };
  openvpn = {
    package = pkgs.openvpn;
  };
  protonvpn-gui = {
    package = pkgs.proton-vpn;
  };
  protonvpn-cli = {
    package = pkgs.proton-vpn-cli;
  };
  teamviewer = {
    package = pkgs.teamviewer;
  };
  trickle = {
    package = pkgs.trickle;
  };
  wireguard = {
    package = pkgs.wireguard-tools;
  };
  nextcloud-client = {
    package = pkgs.nextcloud-client;
  };
  etherape = {
    package = pkgs.etherape;
  };
  angry-ip-scanner = {
    package = pkgs.angryipscanner;
  };
  bind = {
    package = pkgs.bind;
  };
  remmina = {
    package = pkgs.remmina;
  };
  anydesk = {
    package = pkgs.anydesk;
  };
  rustdesk = {
    package = pkgs.rustdesk;
  };
  vnstat = {
    package = pkgs.vnstat;
  };
  nload = {
    package = pkgs.nload;
  };
  nethogs = {
    package = pkgs.nethogs;
  };
  ethtool = {
    package = pkgs.ethtool;
  };
  mtr-gui = {
    package = pkgs.mtr-gui;
  };
  nettools = {
    package = pkgs.nettools;
  };
  dig = {
    package = pkgs.dnsutils;
  };
  speedtest = {
    package = pkgs.speedtest-cli;
  };
  termshark = {
    package = pkgs.termshark;
  };
  syncthingtray.package = pkgs.syncthingtray;
  filezilla.package = pkgs.filezilla;
}
