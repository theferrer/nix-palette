{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    lfs = {
      enable = true;
      skipSmudge = true;
    };

    settings = {
      init.defaultBranch = "main";
      repack.usedeltabaseoffset = "true";
      color.ui = "auto";
      diff.algorithm = "histogram";
      help.autocorrect = 10;

      core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";

      branch = {
        autosetupmerge = "true";
        sort = "committerdate";
      };

      commit.verbose = true;

      fetch.prune = true;

      pull.ff = "only";

      push = {
        default = "current";
        followTags = true;
        autoSetupRemote = true;
      };

      merge = {
        stat = "true";
        conflictstyle = "zdiff3";
        tool = "meld";
      };

      rebase = {
        autoSquash = true;
        autoStash = true;
      };

      rerere = {
        enabled = true;
        autoupdate = true;
      };

      diff.mnemonicprefix = true;

      transfer.fsckObjects = true;
      fetch.fsckObjects = true;
      receive.fsckObjects = true;

      alias = {
        st = "status";
        br = "branch";
        c = "commit -m";
        ca = "commit -am";
        co = "checkout";
        d = "diff";
        fuck = "commit --amend -m";
        graph = "log --all --decorate --graph";
        ps = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
        pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
        af = "!git add $(git ls-files -m -o --exclude-standard | fzf -m)";
        hist = ''
          log --pretty=format:"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)" --graph --date=relative --decorate --all
        '';
        llog = ''
          log --graph --name-status --pretty=format:"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset" --date=relative
        '';
        fuggit = "!git add . && git commit --amend --no-edit && git push --force";
        idc = "!git commit -am '$(curl -s https://whatthecommit.com/index.txt)'";
      };

      url = {
        "ssh://git@github.com/".insteadOf = "github:";
        "ssh://git@gitlab.com/".insteadOf = "gitlab:";
        "ssh://git@codeberg.org/".insteadOf = "codeberg:";
        "ssh://git@git.sr.ht/".insteadOf = "srht:";
        "ssh://aur@aur.archlinux.org/".insteadOf = "aur:";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };
}
