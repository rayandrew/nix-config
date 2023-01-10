{ config, lib, pkgs, ... }:

{
  environment.etc."sudoers.d/custom".text = ''
    Defaults timestamp_timeout=300
  '';
  security.pam.enableSudoTouchIdAuth = true;
  security.pam.sudoTouchIdReattach = {
    enable = true;
    package = pkgs.pam-reattach;
  };
}
