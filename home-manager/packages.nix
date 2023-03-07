{ pkgs, ... }:

{
  home.packages = with pkgs; [
    stable.age
    borgbackup
    bzip2
    cachix
    coreutils-full
    curl
    daemon
    deadnix
    diffutils
    discord
    fd
    fontconfig
    file
    findutils
    gawk
    gcc
    gnugrep
    gnupg
    gnused
    gnutar
    gzip
    hydra-check
    imagemagick
    inetutils
    ipcalc
    jq
    lazygit
    less
    lf # file manager
    lsof
    man
    nb # note taking
    nmap
    nixfmt
    nodejs
    netcat-gnu
    nix-tree
    openssh
    openssl
    pandoc
    p7zip
    python39
    ripgrep
    rsync
    ruby
    scripts
    shellcheck
    sops
    spotify-player
    sshfs-fuse
    trash-cli
    tree
    unar
    unzip
    w3m
    watch
    wget
    xz
    zstd

    # rust
    rustc
    cargo
    # cargo-leptos

    # latex
    texlive.combined.scheme-full

    # gnuplot
    gnuplot_qt

    # node packages
    # nodePackages_latest.readability-cli

    # static website
    hugo

    # task manager
    taskwarrior
    taskwarrior-tui
  ];
}
