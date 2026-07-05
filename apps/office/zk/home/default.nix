{ pkgs, ... }:
{
  home.packages = [ pkgs.zk ];

  xdg.configFile."zk/config.toml".source = pkgs.writers.writeTOML "zk-conf.toml" {
    note = {
      default-title = "untitled";
      id-charset = "hex";
      id-length = 6;
    };

    tool = {
      editor = "nvim";
      pager = "bat";
      fzf-preview = "bat -p --color always {-1}";
    };

    alias = {
      list = "zk list --quiet -f oneline $@";
      ls = "zk list $@";
      wc = "zk list --sort word-count $@";

      search = "zk list -i $@";

      editlast = "zk edit --limit 1 --sort modified- $@";
      recent = "zk edit --sort created- --created-after 'last two weeks' --interactive";
      path = "zk list --quiet --format {{path}} --delimiter , $@";
      hist = "zk list --format path --delimiter0 --quiet $@ | xargs -t -0 git log --patch --";
      tags = "zk tag list $@";
    };
  };
}
