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
      version = "1.0.5";
      sha256 = "sha256-+IFqgWliKr+qjBLmQlzF44XNbN7Br5a119v9WAnZOu4=";
    }
  ];
in
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions;
      [
        vscodevim.vim
        bbenoist.nix
        (ms-python.python.overrideAttrs (finalAttrs: previousAttrs: {
          postPatch = "";
          separateDebugInfo = true;
        }))
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        alefragnani.project-manager
      ] ++ marketplaceExtensions;
    userSettings =
      let
        fontSize = 18;
      in
      {
        "workbench.colorTheme" = "Ayu Light";
        "workbench.startupEditor" = "none";

        # editor
        # "editor.fontFamily" = "Pragmata Pro Mono";
        "editor.fontFamily" = "JetBrainsMono Nerd Font Mono";
        "editor.fontSize" = fontSize;
        "editor.wordWrap" = "on";
        "editor.minimap.enabled" = false;
        "editor.lineNumbers" = "relative";

        # integrated terminal
        "terminal.integrated.fontSize" = fontSize;

        # python
        "python.formatting.provider" = "none";
        "[python]" = {
          "editor.defaultFormatter" = "ms-python.black-formatter";
          "editor.formatOnSave" = true;
        };

        # vim 
        "vim.easymotion" = true;
        "vim.incsearch" = true;
        "vim.useSystemClipboard" = true;
        "vim.useCtrlKeys" = true;
        "vim.hlsearch" = true;
        "vim.insertModeKeyBindings" = [
          {
            "before" = [ "j" "j" ];
            "after" = [ "<Esc>" ];
          }
        ];
        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            "before" = [ "<leader>" "d" ];
            "after" = [ "d" "d" ];
          }
          {
            "before" = [ "<C-n>" ];
            "commands" = [ ":nohl" ];
          }
          {
            "before" = [ "K" ];
            "commands" = [ "lineBreakInsert" ];
            "silent" = true;
          }
          {
            "before" = [ "<leader>" "f" "s" ];
            "commands" = [
              ":w"
            ];
          }
        ];
        "vim.leader" = "<space>";
        "vim.handleKeys" = {
          "<C-a>" = false;
          "<C-f>" = false;
        };
      };
  };
}
