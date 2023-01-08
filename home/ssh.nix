{ config, pkgs, lib, ... }:
# Let-In ----------------------------------------------------------------------------------------{{{
let
  inherit (lib) concatStringsSep optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) directory;
in
# }}}
{
  # SSH 
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.ssh.enable
  programs.ssh.enable = true;

  # programs.ssh.forwardAgent = true;
  # programs.ssh.extraConfig = ''
  #
  # '';

  programs.ssh.matchBlocks = {
    "cl-data" = {
      hostname = "192.5.87.68";
      forwardAgent = true;
      forwardX11 = true;
    };
  };

  # home.file."Library/LaunchAgents/com.1password.SSH_AUTH_SOCK.plist".source = mkOutOfStoreSymlink "${directory.nix}/etc/com.1password.SSH_AUTH_SOCK.plist";

#   home.file."Library/LaunchAgents/com.1password.SSH_AUTH_SOCK.plist".text = ''
# <?xml version="1.0" encoding="UTF-8"?>
# <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
# <plist version="1.0">
#   <dict>
#     <key>Label</key>
#     <string>com.1password.SSH_AUTH_SOCK</string>
#     <key>ProgramArguments</key>
#     <array>
#       <string>/bin/sh</string>
#       <string>-c</string>
#       <string>/bin/ln -sf $HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock \$SSH_AUTH_SOCK</string>
#     </array>
#     <key>RunAtLoad</key>
#     <true/>
#   </dict>
# </plist>
# '';
}
