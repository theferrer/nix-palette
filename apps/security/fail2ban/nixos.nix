{
  config,
  lib,
  canvasLib,
  ...
}:
lib.mkIf (canvasLib.isActive config "fail2ban") {
  services.fail2ban = {
    enable = true;
    banaction = lib.mkDefault "iptables-multiport[blocktype=DROP]";
    maxretry = lib.mkDefault 7;
    ignoreIP = lib.mkDefault [
      "127.0.0.0/8"
      "10.0.0.0/8"
      "192.168.0.0/16"
    ];
  };
}
