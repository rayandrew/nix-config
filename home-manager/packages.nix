{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    age
    # (stable.age.overrideAttrs (final: prev: {
    #   doInstallCheck = !pkgs.stdenv.isDarwin;
    # }))
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
    ripgrep
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

    chafa # image terminal viewer

    broot
    tesseract5

    sqlitebrowser

    du-dust # du replacer
    exa # ls replacer
    alpaca-cpp

    zk
    bitwarden-cli

    pre-commit

    poppler_utils
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    macfuse-stubs
    pkgs.python310Packages.pipx

    thorium-darwin
    # cherrytree-darwin
    # pkgs.darwin.libobjc
    # zowie
  ];
}
