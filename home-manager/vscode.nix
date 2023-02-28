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
    {
      name = "copilot";
      publisher = "GitHub";
      version = "1.73.8685";
      sha256 = "sha256-W1j1VAuSM1sgxHRIahqVncUlknT+MPi7uutY+0NURZQ=";
    }
    {
      name = "ayu";
      publisher = "teabyii";
      version = "1.0.2";
      sha256 = "sha256-ieGuou4NaRzo53qO3YjgJcIv7P2+nAb1Q4yCqIAVRJ0=";
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
    userSettings = let fontSize = 18; in {
      "workbench.colorTheme" = "Ayu Light";
      "workbench.startupEditor" = "none";

      # editor
      # "editor.fontFamily" = "Pragmata Pro Mono";
      "editor.fontFamily" = "JetBrainsMono Nerd Font Mono";
      "editor.fontSize" = fontSize;
      "editor.wordWrap" = "on";
      "editor.minimap.enabled" = false;

      # integrated terminal
      "terminal.integrated.fontSize" = fontSize;

      # python
      "python.formatting.provider" = "none";
      "[python]" = {
        "editor.defaultFormatter" = "ms-python.black-formatter";
        "editor.formatOnSave" = true;
      };
    };
  };
}
