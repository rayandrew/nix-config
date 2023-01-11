{ config, lib, pkgs, ... }:

{
  imports = [ ];
  hm.imports = [ ];

  networking.computerName = "runner";
  networking.hostName = "runner";

  # config.my = {
  #   username = "runner";
  #   directory = {
  #     nix = "/Users/runner/work/nixpkgs/nixpkgs";
  #     projects = "/Users/runner/work/Projects";
  #     research = "/Users/runner/work/Research";
  #   };
  # };

  homebrew.enable = lib.mkForce false;
}
