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
    # signing = {
    # key = "E2E8D63137DD489E";
    # key =
    #   "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMHAzQAtsfWptVuemoBzWLwqdLYTkGNGFiihhXq6Qi3EZk94jpmD2YM/UxzQVgbBCALSaKdTLRiwAfy2C+0sIh8XomiFqgnZ96K+FjSkSkcz9IIL6m8VqCNTcCElK8C5u+MSr611v2giYrJbgEJSdK7assp348B3E2p4opZ5OxYXHL8EOj/5pWjUjLa0CK1SQQJbdjCfw4kqrXelgT8iwVERIU2WO7YlEOgWWEDS7pOseYIHcf77zzcAb6P1b6iEvDvvKuooN0mSZtkOdMmTnEUTKkQQPhkuuMId1GFXl6Y6XscLfxO0fag9pC4QkB5SrgYPX8wCOm+N4ihk3Ok2r5";
    # signByDefault = true;
    # };
    extraConfig = {
      init = { defaultBranch = config.my-meta.mainBranch; };
      gpg = { format = "ssh"; };
    };

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
