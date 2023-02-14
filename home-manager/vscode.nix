{ config, lib, pkgs, ... }:

let
  marketplaceExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "tokyo-night";
      publisher = "enkia";
      version = "0.9.6";
      sha256 = "sha256-Vk6wIGMzWPpv+A4vnHWAYnxTFYQBpVYZNu1BRim/TN0=";
    }
    {
      name = "black-formatter";
      publisher = "ms-python";
      version = "2022.7.13271013";
      sha256 = "sha256-wXAIPrk52L9xZNY3bitMUaUNl5q0iCNmRKK+Z/ZHmsU=";
    }
  ];
in
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions;
      [
        bbenoist.nix
        (ms-python.python.overrideAttrs (finalAttrs: previousAttrs: {
          postPatch = "";
          separateDebugInfo = true;
        }))
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
      ] ++ marketplaceExtensions;
    userSettings = {
      "workbench.colorTheme" = "Tokyo Night";
      "workbench.startupEditor" = "none";
      # "editor.fontFamily" = "Pragmata Pro Mono";
      "editor.fontFamily" = "JetBrainsMono Nerd Font Mono";
      "editor.fontSize" = 18;
      "editor.wordWrap" = "on";
      # python
      "python.formatting.provider" = "none";
      "[python]" = {
        "editor.defaultFormatter" = "ms-python.black-formatter";
        "editor.formatOnSave" = true;
      };
    };
  };
}
