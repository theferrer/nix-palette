{ pkgs }:
{
  # Recon and scanning
  masscan.package = pkgs.masscan;
  rustscan.package = pkgs.rustscan;
  amass.package = pkgs.amass;
  subfinder.package = pkgs.subfinder;
  dnsx.package = pkgs.dnsx;
  dnsrecon.package = pkgs.dnsrecon;

  # Web
  gobuster.package = pkgs.gobuster;
  ffuf.package = pkgs.ffuf;
  feroxbuster.package = pkgs.feroxbuster;
  wfuzz.package = pkgs.wfuzz;
  nuclei.package = pkgs.nuclei;
  httpx.package = pkgs.httpx;
  katana.package = pkgs.katana;
  whatweb.package = pkgs.whatweb;
  nikto.package = pkgs.nikto;
  sqlmap.package = pkgs.sqlmap;
  arjun.package = pkgs.arjun;
  gau.package = pkgs.gau;

  # Traffic and MITM
  tcpdump.package = pkgs.tcpdump;
  tshark.package = pkgs.tshark;
  ngrep.package = pkgs.ngrep;
  mitmproxy.package = pkgs.mitmproxy;
  bettercap.package = pkgs.bettercap;
  responder.package = pkgs.responder;

  # Credentials and cracking
  hashcat.package = pkgs.hashcat;
  john.package = pkgs.john;
  thc-hydra.package = pkgs.thc-hydra;
  medusa.package = pkgs.medusa;

  # Wireless
  aircrack-ng.package = pkgs.aircrack-ng;
  hcxtools.package = pkgs.hcxtools;
  hcxdumptool.package = pkgs.hcxdumptool;

  # TLS
  testssl.package = pkgs.testssl;
  sslscan.package = pkgs.sslscan;

  # RE, binary and analysis
  radare2.package = pkgs.radare2;
  binwalk.package = pkgs.binwalk;
  yara.package = pkgs.yara;

  # Secrets and containers
  trufflehog.package = pkgs.trufflehog;

  # Post-exploitation and pivoting
  proxychains-ng.package = pkgs.proxychains-ng;
  netexec.package = pkgs.netexec;

  # Heavyweights: kept in the catalog but not in the security-tools want,
  # opt in per host via `extra` (multi-GB each).
  metasploit.package = pkgs.metasploit;
  ghidra.package = pkgs.ghidra;
  seclists.package = pkgs.seclists;
}
