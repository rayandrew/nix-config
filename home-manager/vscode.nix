{ config, lib, pkgs, ... }:

let
  marketplaceExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
    name = "tokyo-night";
    publisher = "enkia";
    version = "0.9.4";
    sha256 = "sha256-pKokB6446SR6LsTHyJtQ+FEA07A0W9UAI+byqtGeMGw=";
  }];
in
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions;
      [
        bbenoist.nix
        # ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
      ] ++ marketplaceExtensions;
    userSettings = {
      "workbench.colorTheme" = "Tokyo Night";
      "workbench.startupEditor" = "none";
      # "editor.fontFamily" = "Pragmata Pro Mono";
      "editor.fontFamily" = "Ubuntu Nerd Font";
      "editor.fontSize" = 16;
      "editor.wordWrap" = "on";
    };
  };
}
