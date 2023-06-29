# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ flake
, lib
, config
, pkgs
, ...
}:

let
  inherit (flake) inputs;
  inherit (config.my-meta) username;
  inherit (config.users.users.${username}) home;
in
{
  imports = [
    # Use `nixos-generate-config` to generate `hardware-configuration.nix` file
    ./hardware-configuration.nix
    ../../nixos/minimal.nix
    ../../nixos/security.nix
    ../../nixos/home.nix
    ../../nixos/ssh.nix
    inputs.hardware.nixosModules.common-cpu-intel
  ];

  device = {
    type = "laptop";
    netDevices = [ ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "lemur";
    networkmanager.enable = true;
    usePredictableInterfaceNames = lib.mkDefault false;
    # interfaces.enp0s31f6 = {
    #   ipv4.addresses = [{
    #     address = "128.135.11.17";
    #     prefixLength = 24;
    #   }];
    # };
    # defaultGateway = "128.135.11.1";
    # nameservers = [ "128.135.164.141" "128.135.24.141" ];
    # firewall.allowedTCPPorts = [ 22 ];
  };

  my-meta.nixConfigPath = "${home}/.config/nix-config";
  my-meta.projectsDirPath = "${home}/Projects";
  my-meta.researchDirPath = "${home}/Research";

  users.users.${username}.passwordFile = lib.mkForce config.sops.secrets.home-password.path;


  # home-manager.users.${config.my-meta.username}.imports = [{
  #   programs.git.signing = {
  #     key =
  #       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILqoNddaHxhWrYEReVH3bAW2u74cVUOvIqxeWJdLByB5 rayandrew@ucare-07";
  #     signByDefault = true;
  #   };
  # }];

  security.pam.enableSSHAgentAuth = true; # to make deploy-rs works

  # secrets
  sops.secrets = {
    home-password = {
      # owner = username;
      # group = username;
      mode = "0440";
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
  };
}
