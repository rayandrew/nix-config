{ config, pkgs, ... }:

{
  # Git
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
  # Aliases config in ./configs/git-aliases.nix
  programs.git.enable = true;

  programs.git.extraConfig = {
    diff.colorMoved = "default";
    pull.rebase = true;
  };

  programs.git.ignores = [
    ".DS_Store"
  ];

  programs.git.userEmail = config.home.user-info.email;
  programs.git.userName = config.home.user-info.fullName;
  programs.git.aliases = { };
  programs.git.signing = {
    key = "E2E8D63137DD489E";
    signByDefault = true;
  };
  programs.git.extraConfig = {
    init = { 
      defaultBranch = "main"; 
    };
  };
  # programs.git.includes = { 
  #  {
  #    user = {
  #      email = "4437323+rayandrew@users.noreply.github.com";
  #      name = "Ray Andrew";
  #      signingKey = "3DF30C0071130B7D";
  #    };
  #    commit = {
  #      gpgSign = true;
  #    };
  #  }
  # };

  # Enhanced diffs
  programs.git.delta.enable = true;

  # GitHub CLI
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.gh.enable
  # Aliases config in ./gh-aliases.nix
  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";
}
