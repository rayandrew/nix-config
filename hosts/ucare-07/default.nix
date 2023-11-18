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
    ../../nixos/ssh.nix
    ../../nixos/vps.nix
    ../../nixos/home.nix
    ../../nixos/fhs.nix
    ../../modules/linux/gitea-runner
    inputs.hardware.nixosModules.common-cpu-intel
  ];

  device = {
    type = "server";
    netDevices = [ "enp0s31f6" ];
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/nvme0n1";
    useOSProber = true;
  };

  networking = {
    hostName = "ucare-07";
    domain = "cs.uchicago.edu";
    networkmanager.enable = true;
    usePredictableInterfaceNames = lib.mkDefault true;
    interfaces.enp0s31f6 = {
      ipv4.addresses = [{
        address = "128.135.11.17";
        prefixLength = 24;
      }];
    };
    defaultGateway = "128.135.11.1";
    nameservers = [ "128.135.164.141" "128.135.24.141" ];
    firewall.allowedTCPPorts = [ 22 ];
  };


  services.openssh.forwardX11 = lib.mkDefault true;

  my-meta.nixConfigPath = "${home}/.config/nix-config";
  my-meta.projectsDirPath = "${home}/Projects";
  my-meta.researchDirPath = "${home}/Research";

  users.extraUsers.daniar = {
    isNormalUser = true;
    home = "/home/daniar";
    description = "Daniar Kurniawan";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;
    passwordFile = config.sops.secrets.daniar.path;
    openssh.authorizedKeys.keys = [ ];
  };

  users.groups.data.members = [
    "root"
    username

  ];

  # home-manager.users.${config.my-meta.username}.imports = [{
  #   programs.git.signing = {
  #     key =
  #       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILqoNddaHxhWrYEReVH3bAW2u74cVUOvIqxeWJdLByB5 rayandrew@ucare-07";
  #     signByDefault = true;
  #   };
  # }];

  security.pam.enableSSHAgentAuth = true; # to make deploy-rs works

  services.gitea-runner = {
    enable = true;
    package = pkgs.unstable.gitea-actions-runner;
    instanceUrl = "https://git.rs.ht";
    tokenFile = config.sops.secrets.gitea-runner-token.path;
  };

  # secrets
  sops.secrets = {
    gitea-runner-token = {
      owner = "gitea-runner";
      group = "gitea-runner";
      mode = "0440";
      sopsFile = ./secrets.yaml;
      # neededForUsers = true;
    };
    daniar = {
      owner = config.users.users.daniar.name;
      group = config.users.users.daniar.group;
      mode = "0440";
      sopsFile = ./secrets.yaml;
    };
  };
}
