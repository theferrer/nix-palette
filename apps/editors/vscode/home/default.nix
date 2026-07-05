{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    mutableExtensionsDir = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [

      github.copilot
      github.copilot-chat
      github.vscode-pull-request-github
      github.vscode-github-actions
      eamodio.gitlens

      ms-vscode-remote.remote-ssh
      ms-vscode.live-server
      vscodevim.vim
      wakatime.vscode-wakatime

      jnoortheen.nix-ide
      kamadorueda.alejandra
      mkhl.direnv

      serayuzgur.crates

      golang.go

      sumneko.lua

      tamasfe.even-better-toml

      bradlc.vscode-tailwindcss
      dbaeumer.vscode-eslint
      denoland.vscode-deno

      shd101wyy.markdown-preview-enhanced
      unifiedjs.vscode-mdx
      valentjn.vscode-ltex
    ];
  };
}
