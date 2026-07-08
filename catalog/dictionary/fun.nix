{ pkgs }:
{
  cmatrix = {
    package = pkgs.cmatrix;
  };
  cowsay = {
    package = pkgs.cowsay;
  };
  nyancat = {
    package = pkgs.nyancat;
  };
  pipes = {
    package = pkgs.pipes;
  };
  sl = {
    package = pkgs.sl;
  };
  fortune = {
    package = pkgs.fortune;
  };
  lolcat = {
    package = pkgs.lolcat;
  };
  asciiquarium = {
    package = pkgs.asciiquarium;
  };
  dotacat = {
    package = pkgs.dotacat;
  };

  # Screen visuals and novelty
  cbonsai.package = pkgs.cbonsai;
  pipes-rs.package = pkgs.pipes-rs;
  unimatrix.package = pkgs.unimatrix;
  neo.package = pkgs.neo;
  tmatrix.package = pkgs.tmatrix;
  hollywood.package = pkgs.hollywood;
  genact.package = pkgs.genact;
  terminal-parrot.package = pkgs.terminal-parrot;
  gay.package = pkgs.gay;
  rig.package = pkgs.rig;
  oneko.package = pkgs.oneko;
  xcowsay.package = pkgs.xcowsay;

  # ASCII art and text
  figlet.package = pkgs.figlet;
  toilet.package = pkgs.toilet;
  boxes.package = pkgs.boxes;
  banner.package = pkgs.banner;
  ponysay.package = pkgs.ponysay;
  neo-cowsay.package = pkgs.neo-cowsay;
  charasay.package = pkgs.charasay;

  # Sprites
  krabby.package = pkgs.krabby;
  pokemonsay.package = pkgs.pokemonsay;

  # Fetch toys
  pfetch.package = pkgs.pfetch;
  nerdfetch.package = pkgs.nerdfetch;
  cpufetch.package = pkgs.cpufetch;
  starfetch.package = pkgs.starfetch;
  nitch.package = pkgs.nitch;
  macchina.package = pkgs.macchina;
  owofetch.package = pkgs.owofetch;

  # Terminal games
  nsnake.package = pkgs.nsnake;
  ninvaders.package = pkgs.ninvaders;
  moon-buggy.package = pkgs.moon-buggy;
  vitetris.package = pkgs.vitetris;
  bastet.package = pkgs.bastet;
  "2048".package = pkgs._2048-in-terminal;
  nudoku.package = pkgs.nudoku;
  greed.package = pkgs.greed;
  freesweep.package = pkgs.freesweep;
  nethack.package = pkgs.nethack;
  crawl.package = pkgs.crawl;
  angband.package = pkgs.angband;
  gnugo.package = pkgs.gnugo;
}
