{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    age
    borgbackup
    bzip2
    cachix
    curl
    diffutils
    fd
    file
    findutils
    fup-repl
    gawk
    gcc
    gnugrep
    gnupg
    gnused
    gnutar
    gzip
    htop
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
  ];
}
