{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.pam;

  mkSudoTouchIdAuthReattachScript = { enable, package }:
    let
      file = "/etc/pam.d/sudo";
      option = "security.pam.sudoTouchIdReattach";
      pkg = "${package}/lib/pam/pam_reattach.so";
      sed = "${pkgs.gnused}/bin/sed";
    in
    ''
      ${if enable && (pkgs.system == "aarch64-darwin") then ''
        # Enable sudo Touch ID authentication, if not already enabled
        if ! grep 'pam_reattach.so' ${file} > /dev/null; then
          ${sed} -i '2i\
        auth       optional       ${pkg} ignore-ssh # nix-darwin: ${option}
          ' ${file}
        fi
      '' else ''
        # Disable sudo Touch ID authentication, if added by nix-darwin
        if grep '${option}' ${file} > /dev/null; then
          ${sed} -i '/${option}/d' ${file}
        fi
      ''}
    '';

in
{
  options = with types; {
    security.pam.sudoTouchIdReattach.enable = mkEnableOption ''
      Whether to enable the sudo Touch ID Reattach";
    '';

    security.pam.sudoTouchIdReattach.package = mkOption {
      type = path;
      default = pkgs.pam-reattach;
      description = "The `pam_reattach` package to use.";
    };
  };

  config = {
    system.activationScripts.postActivation.text = mkBefore ''
      # PAM settings
      echo >&2 "setting up pam-reattach..."
      ${mkSudoTouchIdAuthReattachScript cfg.sudoTouchIdReattach}
    '';
  };
}
