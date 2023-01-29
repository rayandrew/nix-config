{ config, pkgs, ... }:

{
  # Git
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
  # Aliases config in ./configs/git-aliases.nix
  programs.git = {
    enable = true;
    userEmail = config.my-meta.email;
    userName = config.my-meta.name;
    extraConfig = {
      diff.colorMoved = "default";
      pull.rebase = true;
    };

    ignores = [ ".DS_Store" ];

    aliases = { };
    signing = {
      key = "E2E8D63137DD489E";
      signByDefault = true;
    };
    extraConfig = { init = { defaultBranch = config.my-meta.mainBranch; }; };

    # Enhanced diffs
    delta.enable = true;
  };

  # GitHub CLI
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.gh.enable
  # Aliases config in ./gh-aliases.nix
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
