{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # age
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
    lsof
    man
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
    trash-cli
    tree
    unar
    unzip
    watch
    xz
    zstd

    # rust
    rustc
    cargo

    # latex
    texlive.combined.scheme-full

    # gnuplot
    gnuplot_qt

    # static website
    hugo
  ];
}
