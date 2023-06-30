{ config, pkgs, ... }:
let
  inherit (config.my-meta) username;
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;
    # password = "changeme";
    passwordFile = config.sops.secrets.rayandrew-password.path;
  };

  sops.secrets = {
    rayandrew-password = {
      mode = "0440";
      sopsFile = ../secrets.yaml;
      neededForUsers = true;
    };
  };
}
