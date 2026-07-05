{ pkgs }:
{
  alejandra = {
    package = pkgs.alejandra;
  };
  bruno = {
    package = pkgs.bruno;
  };
  bun = {
    package = pkgs.bun;
  };
  deadnix = {
    package = pkgs.deadnix;
  };
  devenv = {
    package = pkgs.devenv;
  };
  go = {
    package = pkgs.go;
  };
  mongodb-compass = {
    package = pkgs.mongodb-compass;
  };
  mongosh = {
    package = pkgs.mongosh;
  };
  nodejs = {
    package = pkgs.nodejs;
  };
  repl = {
    package = pkgs.evcxr;
  };
  redisinsight = {
    package = pkgs.redisinsight;
  };
  robo3t = {
    package = pkgs.robo3t;
  };
  rustup = {
    package = pkgs.rustup;
  };

  cmake = {
    package = pkgs.cmake;
  };
  gnumake = {
    package = pkgs.gnumake;
  };
  meson = {
    package = pkgs.meson;
  };
  gcc = {
    package = pkgs.gcc;
  };
  binutils = {
    package = pkgs.binutils;
  };

  dbeaver = {
    package = pkgs.dbeaver-bin;
  };

  httpie = {
    package = pkgs.httpie;
  };
  insomnia = {
    package = pkgs.insomnia;
  };
  postman = {
    package = pkgs.postman;
  };

  python = {
    package = pkgs.python3;
  };
  php = {
    package = pkgs.php;
  };

  zeal = {
    package = pkgs.zeal;
  };

  yq = {
    package = pkgs.yq;
  };
  tig = {
    package = pkgs.tig;
  };
  wakatime-cli = {
    package = pkgs.wakatime-cli;
  };

  git-credential-manager = {
    package = pkgs.git-credential-manager;
  };
  gitui = {
    package = pkgs.gitui;
  };
  jetbrains = {
    package = pkgs.jetbrains.idea;
  };
  sublime = {
    package = pkgs.sublime4;
  };
  cursor = {
    package = pkgs.code-cursor;
  };
  webstorm = {
    package = pkgs.jetbrains.webstorm;
  };
  rustrover = {
    package = pkgs.jetbrains.rust-rover;
  };
  simplescreenrecorder = {
    package = pkgs.simplescreenrecorder;
  };
  screenkey = {
    package = pkgs.screenkey;
  };

  claude-code = {
    package = pkgs.claude-code;
  };
  opencode = {
    package = pkgs.opencode;
  };
  codex = {
    package = pkgs.codex;
  };

  kubectl = {
    package = pkgs.kubectl;
  };
  minikube = {
    package = pkgs.minikube;
  };
  docker-compose = {
    package = pkgs.docker-compose;
  };
  podman-desktop = {
    package = pkgs.podman-desktop;
  };
  kubernetes-helm = {
    package = pkgs.kubernetes-helm;
  };
  terraform = {
    package = pkgs.terraform;
  };
  argocd = {
    package = pkgs.argocd;
  };
  awscli = {
    package = pkgs.awscli2;
  };
  azure-cli = {
    package = pkgs.azure-cli;
  };
  yarn.package = pkgs.yarn;
  intelephense.package = pkgs.intelephense;
  android-tools.package = pkgs.android-tools;
  nosqlbooster4mongo.package = pkgs.nosqlbooster4mongo;
}
