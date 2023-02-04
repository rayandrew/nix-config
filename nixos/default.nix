{ config, lib, pkgs, flake, ... }:

{
  imports = [
    ./home.nix
    ./minimal.nix
  ];
}
