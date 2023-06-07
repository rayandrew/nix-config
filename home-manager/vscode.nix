{ config, lib, pkgs, ... }:

let
  # generateVimKeybinding = is_neovim:
  #   let
  #     normal = if is_neovim then "neovim.mode == normal" else "vim.mode == 'Normal'";
  #     insert = if is_neovim then "neovim.mode == insert" else "vim.mode == 'Insert'";
  #     visual = if is_neovim then "neovim.mode == visual" else "vim.mode == 'Visual'";
  #   in
  generateNeovimKeybinding =
    [
      {
        command = "vscode-neovim.compositeEscape1";
        key = "j";
        when = "neovim.mode == insert && editorTextFocus";
        args = "j";
      }
      {
        command = "vscode-neovim.compositeEscape2";
        key = "k";
        when = "neovim.mode == insert && editorTextFocus";
        args = "k";
      }
      {
        command = "find-it-faster.findFiles";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space F F";
      }
      {
        command = "find-it-faster.findWithinFiles";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space S P";
      }
      {
        command = "find-it-faster.findWithinFiles";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space /";
      }
      {
        command = "workbench.action.toggleSidebarVisibility";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space E";
      }
      {
        command = "workbench.action.splitEditor";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space W V";
      }
      {
        command = "workbench.action.splitEditorDown";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space W S";
      }
      {
        command = "workbench.action.closeActiveEditor";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space W Q";
      }
      {
        command = "workbench.action.closeActiveEditor";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space B D";
      }
      {
        command = "workbench.action.files.save";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space F S";
      }
      {
        command = "find-it-faster.findWithinFilesWithType";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space F T";
      }
      {
        command = "workbench.action.quickOpenPreviousRecentlyUsedEditor";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space B B";
      }
      {
        command = "workbench.action.navigateLeft";
        key = "ctrl+H";
      }
      {
        command = "workbench.action.navigateLeft";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space W H";
      }
      {
        command = "workbench.action.navigateRight";
        key = "ctrl+L";
      }
      {
        command = "workbench.action.navigateRight";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space W L";
      }
      {
        command = "workbench.action.navigateUp";
        key = "ctrl+K";
      }
      {
        command = "workbench.action.navigateUp";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space W K";
      }
      {
        command = "workbench.action.navigateDown";
        key = "ctrl+J";
      }
      {
        command = "workbench.action.navigateDown";
        when = "neovim.mode == normal && editorTextFocus";
        key = "space W J";
      }

    ];

  generateVimKeybinding = [ ];
  fontSize = 18;
in
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions;
      [
        vscodevim.vim
        bbenoist.nix
        # ms-python.python
        # (ms-python.python.overrideAttrs (finalAttrs: previousAttrs: {
        #   postPatch = "";
        #   separateDebugInfo = true;
        # }))
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        alefragnani.project-manager
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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
    userSettings =
      {
        "telemetry.telemetryLevel" = "off";

        "update.mode" = "none";

        # "workbench.colorTheme" = "Ayu Light";
        # "workbench.colorTheme" = "Gruvbox Dark Medium";
        # "workbench.colorTheme" = "GitHub Light";
        # "workbench.colorTheme" = "Catppuccin Mocha";
        # "workbench.colorTheme" = "Catppuccin Latte";
        "workbench.colorTheme" = "Catppuccin Macchiato";
        "workbench.startupEditor" = "none";
        "workbench.activityBar.visible" = false;
        "workbench.statusBar.visible" = false;
        "workbench.layoutControl.enabled" = false;
        "workbench.layoutControl.type" = "menu";
        "workbench.editor.limit.enabled" = true;
        "workbench.editor.limit.value" = 1;
        "workbench.editor.limit.perEditorGroup" = true;
        "workbench.editor.showTabs" = false;
        "workbench.editor.enablePreview" = false;

        "breadcrumbs.enabled" = false;
        "explorer.openEditors.visible" = 0;
        "window.commandCenter" = true;

        # editor
        # "editor.fontFamily" = "Pragmata Pro Mono";
        "editor.renderControlCharacters" = false;
        # "editor.fontFamily" = "JetBrainsMono Nerd Font Mono";
        "editor.fontFamily" = "UbuntuMono Nerd Font Mono";
        "editor.fontSize" = fontSize;
        "editor.wordWrap" = "on";
        "editor.minimap.enabled" = false;
        "editor.lineNumbers" = "relative";
        "editor.scrollbar.verticalScrollbarSize" = 2;
        "editor.scrollbar.horizontalScrollbarSize" = 2;
        "editor.scrollbar.vertical" = "hidden";
        "editor.scrollbar.horizontal" = "hidden";
        "editor.accessibilitySupport" = "off";

        # integrated terminal
        "terminal.integrated.fontSize" = fontSize;
        "terminal.integrated.allowChords" = false;

        # python
        "python.formatting.provider" = "none";
        "[python]" = {
          "editor.defaultFormatter" = "ms-python.black-formatter";
          "editor.formatOnSave" = true;
          "editor.codeActionsOnSave" = {
            "source.organizeImports" = true;
          };
        };
        "isort.args" = [ "--profile" "black" ];

        # vim 
        "vim.easymotion" = true;
        "vim.incsearch" = true;
        "vim.useSystemClipboard" = true;
        "vim.useCtrlKeys" = true;
        "vim.hlsearch" = true;
        "vim.insertModeKeyBindings" = [
          {
            before = [ "j" "j" ];
            after = [ "<Esc>" ];
          }
        ];
        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            before = [ "<leader>" "d" ];
            after = [ "d" "d" ];
          }
          {
            before = [ "j" ];
            after = [ "g" "j" ];
          }
          {
            before = [ "k" ];
            after = [ "g" "k" ];
          }
          {
            before = [ "<C-n>" ];
            commands = [ ":nohl" ];
          }
          {
            before = [ "K" ];
            commands = [ "editor.action.peekDefinition" ];
          }
          {
            before = [ "<leader>" "f" "s" ];
            commands = [ ":w" ];
          }
          {
            before = [ "<leader>" "e" ];
            commands = [ "workbench.action.toggleSidebarVisibility" ];
          }
          {
            before = [ "<leader>" "s" "p" ];
            commands = [ "find-it-faster.findWithinFiles" ];
          }
          {
            before = [ "<leader>" "s" "/" ];
            commands = [ "find-it-faster.findWithinFiles" ];
          }
          {
            before = [ "<leader>" "f" "f" ];
            commands = [ "find-it-faster.findFiles" ];
          }
          {
            before = [ "<leader>" "w" "v" ];
            after = [ "<C-w>" "v" ];
          }
          {
            before = [ "<leader>" "w" "s" ];
            after = [ "<C-w>" "s" ];
          }
          {
            before = [ "<leader>" "w" "q" ];
            after = [ "<C-w>" "q" ];
          }
          {
            before = [ "<C-j>" ];
            after = [ "<C-w>" "j" ];
          }
          {
            before = [ "<leader>" "w" "h" ];
            after = [ "<C-w>" "h" ];
          }
          {
            before = [ "<C-j>" ];
            after = [ "<C-w>" "j" ];
          }
          {
            before = [ "<leader>" "w" "j" ];
            after = [ "<C-w>" "j" ];
          }
          {
            before = [ "<C-k>" ];
            after = [ "<C-w>" "k" ];
          }
          {
            before = [ "<leader>" "w" "k" ];
            after = [ "<C-w>" "k" ];
          }
          {
            before = [ "<C-l>" ];
            after = [ "<C-w>" "l" ];
          }
          {
            before = [ "<leader>" "w" "l" ];
            after = [ "<C-w>" "l" ];
          }
          {
            before = [ "<leader>" "b" "d" ];
            commands = [ ":bd" ];
          }
          {
            before = [ "<leader>" "b" "b" ];
            commands = [ "workbench.action.openPreviousEditorFromHistory" ];
          }
        ];
        "vim.leader" = "<space>";
        "vim.handleKeys" = {
          "<C-a>" = false;
          "<C-f>" = false;
        };
      };
    keybindings = [
      {
        key = "enter";
        command = "explorer.openAndPassFocus";
        when = "filesExplorerFocus && foldersViewVisible && !explorerResourceIsFolder && !inputFocus";
      }
      {
        # key = "shift+enter";
        key = "r";
        command = "renameFile";
        when = "filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
      }
      {
        key = "tab";
        command = "togglePeekWidgetFocus";
        when = "inReferenceSearchEditor && vim.active && vim.mode != 'Insert' || referenceSearchVisible";
      }
      {
        key = "ctrl+tab";
        command = "workbench.action.openPreviousEditorFromHistory";
      }
      {
        key = "ctrl+tab";
        command = "workbench.action.quickOpenNavigateNext";
        "when" = "inQuickOpen";
      }
    ] ++ generateNeovimKeybinding;

  };
}
