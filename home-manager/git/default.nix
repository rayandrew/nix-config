{ config
, pkgs
, lib
, ...
}:

let
  homeDir = config.home.homeDirectory;
in
{
  # home.packages = with pkgs; [
  #   git-lfs
  # ];

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
    includes = [
      { path = ./themes.gitconfig; }
    ];

    aliases = { };
    signing = {
      key = if pkgs.stdenv.isDarwin then "A9E68F266CC3879D" else "${homeDir}/.ssh/id_ed25519.pub";
      # key = "${homeDir}/.ssh/id_ed25519.pub";
      signByDefault = true;
      # gpgPath = "${pkgs.gnupg}/bin/gpg";
      gpgPath = if (pkgs.stdenv.isDarwin) then "${pkgs.gnupg}/bin/gpg" else "";
    };
    extraConfig = {
      init = { defaultBranch = config.my-meta.mainBranch; };
      gpg = lib.mkIf (pkgs.stdenv.isLinux) { format = "ssh"; };
    };

    # Enhanced diffs
    delta = {
      enable = true;
      options = {
        features = "coracias-caudatus";
      };
    };

    lfs.enable = true;
  };

  # GitHub CLI
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.gh.enable
  # Aliases config in ./gh-aliases.nix
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
