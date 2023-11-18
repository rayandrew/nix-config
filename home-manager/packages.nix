{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    age
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
    gnumake
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
    less
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
    rsync
    ruby
    scripts
    shellcheck
    sops
    # spotify-player
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
    # rustc
    # cargo
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

    chafa # image terminal viewer

    broot
    tesseract5

    sqlitebrowser

    du-dust # du replacer
    eza # ls replacer
    alpaca-cpp

    zk
    bitwarden-cli

    pre-commit

    poppler_utils
    viu
    aerc
    glow
    zathura
    cmake
    nil
    libtool
    libiconv

    gdb
    zlib

    isync
    _1password
    pass

    xdg-utils
    libxml2
    subversion
    mosh
    meson
    glib
    pkg-config

    mupdf
    ispell
    imagemagick

    libnotify
    rlwrap

    rye
    ghostscript
    unrar
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    macfuse-stubs
    pkgs.python310Packages.pipx
    glibtool
  ];
}
