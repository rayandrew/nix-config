{ config, pkgs, lib, ... }:

# let
  # inherit (lib) optionalString mkAfter;
  # controlChannel = "${config.home.homeDirectory}/.ssh/.control_channels";
# in
{
  # SSH
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.ssh.enable
  # programs.ssh.enable = true;
  home.packages = with pkgs; [
    # SSH
    openssh
  ];
}
