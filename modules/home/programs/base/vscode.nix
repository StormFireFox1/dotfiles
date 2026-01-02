{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.fireflake.programs;
in
{
  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      profiles.default = {
        extensions =
          (with pkgs.vscode-extensions; [
            # Theme
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
            # Nix
            jnoortheen.nix-ide
            # Markdown
            yzhang.markdown-all-in-one
            davidanson.vscode-markdownlint
            bierner.markdown-preview-github-styles
            rust-lang.rust-analyzer
            ziglang.vscode-zig
            golang.go
            ms-python.python
            # C/C++
            llvm-vs-code-extensions.vscode-clangd
            ms-vscode.cpptools
            hashicorp.terraform
            redhat.vscode-yaml
            ms-azuretools.vscode-docker
            # Typst
            myriad-dreamin.tinymist
            ms-kubernetes-tools.vscode-kubernetes-tools
            bazelbuild.vscode-bazel
            # VSpaceCode
            vspacecode.vspacecode
          ])
          ++ (with pkgs.vscode-marketplace; [
            anthropic.claude-code
            # Jujutsu
            jjk.jjk
            # Vim + Which-key
            vscodevim.vim
            vspacecode.whichkey
          ]);
        userSettings = {
          "workbench.colorTheme" = "Catppuccin Mocha";
          "workbench.iconTheme" = "catppuccin-mocha";
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";

          # Vim settings
          "vim.leader" = "<space>";
          "vim.useSystemClipboard" = true;
          "vim.hlsearch" = true;
          "vim.incsearch" = true;
          "vim.smartcase" = true;
          "vim.useCtrlKeys" = true;
          "vim.handleKeys" = {
            "<C-a>" = false;
            "<C-f>" = false;
          };

          # Easymotion (ace-jump)
          "vim.easymotion" = true;
          "vim.easymotionMarkerForegroundColorOneChar" = "#f38ba8";
          "vim.easymotionMarkerForegroundColorTwoCharFirst" = "#fab387";
          "vim.easymotionMarkerForegroundColorTwoCharSecond" = "#f9e2af";

          "editor.lineNumbers" = "relative";

          # Bind s to easymotion search (like leap/flash)
          "vim.normalModeKeyBindings" = [
            {
              before = [ "s" ];
              after = [
                "<leader>"
                "<leader>"
                "s"
              ];
            }
          ];
          "vim.visualModeKeyBindings" = [
            {
              before = [ "s" ];
              after = [
                "<leader>"
                "<leader>"
                "s"
              ];
            }
          ];

          "vim.normalModeKeyBindingsNonRecursive" = [
            {
              before = [ "<space>" ];
              commands = [ "vspacecode.space" ];
            }
            {
              before = [ "," ];
              commands = [
                "vspacecode.space"
                {
                  command = "whichkey.triggerKey";
                  args = "m";
                }
              ];
            }
          ];
          "vim.visualModeKeyBindingsNonRecursive" = [
            {
              before = [ "<space>" ];
              commands = [ "vspacecode.space" ];
            }
            {
              before = [ "," ];
              commands = [
                "vspacecode.space"
                {
                  command = "whichkey.triggerKey";
                  args = "m";
                }
              ];
            }
            {
              before = [ ">" ];
              commands = [ "editor.action.indentLines" ];
            }
            {
              before = [ "<" ];
              commands = [ "editor.action.outdentLines" ];
            }
          ];

          # Fish as main shell
          "terminal.integrated.defaultProfile.linux" = "fish";
          # Terminal profiles for lazygit and jjui
          "terminal.integrated.profiles.linux" = {
            fish = {
              path = "fish";
            };
            lazygit = {
              path = "lazygit";
            };
            jjui = {
              path = "jjui";
            };
          };
          "vspacecode.bindingOverrides" = [
            {
              keys = "g.g";
              name = "Open Lazygit";
              type = "command";
              command = "workbench.action.terminal.newWithProfile";
              args = {
                profileName = "lazygit";
              };
            }
            {
              keys = "j.j";
              name = "Open jjui";
              type = "command";
              command = "workbench.action.terminal.newWithProfile";
              args = {
                profileName = "jjui";
              };
            }
          ];
        };
        keybindings = [
          # Keybindings for VSpaceCode stolen directly from the docs:
          # https://vspacecode.github.io/docs/
          # Trigger vspacecode in empty editor group
          {
            key = "space";
            command = "vspacecode.space";
            when = "activeEditorGroupEmpty && focusedView == '' && !whichkeyActive && !inputFocus";
          }
          # Trigger vspacecode when sidebar is in focus
          {
            key = "space";
            command = "vspacecode.space";
            when = "sideBarFocus && !inputFocus && !whichkeyActive";
          }
          # Keybindings required for edamagit
          # https://github.com/kahole/edamagit#vim-support-vscodevim
          # Cannot be added to package.json because keybinding replacements
          {
            key = "tab";
            command = "extension.vim_tab";
            when = "editorTextFocus && vim.active && !inDebugRepl && vim.mode != 'Insert' && editorLangId != 'magit'";
          }
          {
            key = "tab";
            command = "-extension.vim_tab";
            when = "editorTextFocus && vim.active && !inDebugRepl && vim.mode != 'Insert'";
          }
          {
            key = "x";
            command = "magit.discard-at-point";
            when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
          }
          {
            key = "k";
            command = "-magit.discard-at-point";
          }
          {
            key = "-";
            command = "magit.reverse-at-point";
            when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
          }
          {
            key = "v";
            command = "-magit.reverse-at-point";
          }
          {
            key = "shift+-";
            command = "magit.reverting";
            when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
          }
          {
            key = "shift+v";
            command = "-magit.reverting";
          }
          {
            key = "shift+o";
            command = "magit.resetting";
            when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
          }
          {
            key = "shift+x";
            command = "-magit.resetting";
          }
          {
            key = "x";
            command = "-magit.reset-mixed";
          }
          {
            key = "ctrl+u x";
            command = "-magit.reset-hard";
          }
          # Extra ref menu support for edamagit with the key "y"
          # Cannot be added to package.json because keybinding replacements
          {
            key = "y";
            command = "-magit.show-refs";
          }
          {
            key = "y";
            command = "vspacecode.showMagitRefMenu";
            when = "editorTextFocus && editorLangId == 'magit' && vim.mode == 'Normal'";
          }
          # Extra refresh menu support for edamagit with the key "g"
          # Cannot be added to package.json because keybinding replacements
          {
            key = "g";
            command = "-magit.refresh";
            when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
          }
          {
            key = "g";
            command = "vspacecode.showMagitRefreshMenu";
            when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
          }
          # Easy navigation in quick open/QuickPick
          {
            key = "ctrl+j";
            command = "workbench.action.quickOpenSelectNext";
            when = "inQuickOpen";
          }
          {
            key = "ctrl+k";
            command = "workbench.action.quickOpenSelectPrevious";
            when = "inQuickOpen";
          }
          # Easy navigation in suggestion/intellisense
          # Cannot be added to package.json because of conflict with vim's default bindings
          {
            key = "ctrl+j";
            command = "selectNextSuggestion";
            when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
          }
          {
            key = "ctrl+k";
            command = "selectPrevSuggestion";
            when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
          }
          {
            key = "ctrl+l";
            command = "acceptSelectedSuggestion";
            when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
          }
          # Easy navigation in parameter hint (i.e. traverse the hints when there's multiple overload for one method)
          # Cannot be added to package.json because of conflict with vim's default bindings
          {
            key = "ctrl+j";
            command = "showNextParameterHint";
            when = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
          }
          {
            key = "ctrl+k";
            command = "showPrevParameterHint";
            when = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
          }
          # Easy navigation in code action
          {
            key = "ctrl+j";
            command = "selectNextCodeAction";
            when = "codeActionMenuVisible";
          }
          {
            key = "ctrl+k";
            command = "selectPrevCodeAction";
            when = "codeActionMenuVisible";
          }
          {
            key = "ctrl+l";
            command = "acceptSelectedCodeAction";
            when = "codeActionMenuVisible";
          }
          # Add ctrl+h/l to navigate in file browser
          {
            key = "ctrl+h";
            command = "file-browser.stepOut";
            when = "inFileBrowser";
          }
          {
            key = "ctrl+l";
            command = "file-browser.stepIn";
            when = "inFileBrowser";
          }
        ];
      };
    };
  };
}
