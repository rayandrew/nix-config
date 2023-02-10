{ config, ... }:
let
  inherit (config.my-meta) username;
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAIIF4r+0JPTUDj0/FdTLWebbkFfRXd3Gn11Ai1MZsMt rayandrew@cs.uchicago.edu"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMHAzQAtsfWptVuemoBzWLwqdLYTkGNGFiihhXq6Qi3EZk94jpmD2YM/UxzQVgbBCALSaKdTLRiwAfy2C+0sIh8XomiFqgnZ96K+FjSkSkcz9IIL6m8VqCNTcCElK8C5u+MSr611v2giYrJbgEJSdK7assp348B3E2p4opZ5OxYXHL8EOj/5pWjUjLa0CK1SQQJbdjCfw4kqrXelgT8iwVERIU2WO7YlEOgWWEDS7pOseYIHcf77zzcAb6P1b6iEvDvvKuooN0mSZtkOdMmTnEUTKkQQPhkuuMId1GFXl6Y6XscLfxO0fag9pC4QkB5SrgYPX8wCOm+N4ihk3Ok2r5"
  ];
in
{
  # Enable OpenSSH
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # Enable mosh
  programs.mosh.enable = true;

  # Add SSH key
  users.users.root.openssh.authorizedKeys.keys = sshKeys;
  users.extraUsers.${username}.openssh.authorizedKeys.keys = sshKeys;
}
