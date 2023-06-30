# https://haseebmajid.dev/posts/2023-06-20-til-how-to-declaratively-setup-mullvad-with-nixos/

{ pkgs
, lib
, config
, ...
}:

let
  inherit (config.my-meta) username;
  mullvad = "${config.services.mullvad-vpn.package}/bin/mullvad";
in
{
  services.mullvad-vpn = {
    enable = true;
  };

  systemd.services."mullvad-daemon".preStart = ''
  '';

  systemd.services."mullvad-daemon".postStart = ''
    while ! ${mullvad} status >/dev/null; do sleep 1; done
    ID=`head -n1 ${config.sops.secrets.mullvad.path}`
    ${mullvad} account login "$ID"
    ${mullvad} auto-connect set on
    ${mullvad} relay set location us
    ${mullvad} tunnel ipv6 set on
    ${mullvad} dns set default \
       --block-ads --block-malware --block-trackers
  '';

  sops.secrets = {
    mullvad = {
      owner = username;
      mode = "0440";
      sopsFile = ../secrets.yaml;
    };
  };
}
