{ config, ... }:
let
  inherit (config.my-meta) username sshKeys;
in
{
  # Enable OpenSSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  programs.ssh.startAgent = true;

  # Enable mosh
  programs.mosh.enable = true;

  # Add SSH key
  users.users.root.openssh.authorizedKeys.keys = sshKeys;
  users.extraUsers.${username}.openssh.authorizedKeys.keys = sshKeys;
}
