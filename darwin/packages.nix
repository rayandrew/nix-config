{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    coreutils-full
    daemon
    hydra-check
    fontconfig
    texlive.combined.scheme-full
    discord
  ];
}
