{ lib, pkgs, ... }:
{
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

        "whichkey.delay" = 300;
        "whichkey.sortOrder" = "alphabetically";

        # Which-key bindings. Basically copied from LazyVim.
        "whichkey.bindings" = [
          {
            key = " ";
            name = "Quick Open";
            type = "command";
            command = "workbench.action.quickOpen";
          }
          {
            key = "g";
            name = "+git";
            type = "bindings";
            bindings = [
              {
                key = "g";
                name = "Lazygit";
                type = "command";
                command = "workbench.action.terminal.newWithProfile";
                args = {
                  profileName = "lazygit";
                };
              }
              {
                key = "s";
                name = "Git status";
                type = "command";
                command = "git.status";
              }
              {
                key = "b";
                name = "Git blame";
                type = "command";
                command = "git.blameFile";
              }
            ];
          }
          {
            key = "j";
            name = "+jujutsu";
            type = "bindings";
            bindings = [
              {
                key = "j";
                name = "jjui";
                type = "command";
                command = "workbench.action.terminal.newWithProfile";
                args = {
                  profileName = "jjui";
                };
              }
            ];
          }
          {
            key = "t";
            name = "+terminal";
            type = "bindings";
            bindings = [
              {
                key = "t";
                name = "Toggle terminal";
                type = "command";
                command = "workbench.action.terminal.toggleTerminal";
              }
              {
                key = "n";
                name = "New terminal";
                type = "command";
                command = "workbench.action.terminal.new";
              }
              {
                key = "m";
                name = "Maximize panel";
                type = "command";
                command = "workbench.action.toggleMaximizedPanel";
              }
            ];
          }
          {
            key = "f";
            name = "+find";
            type = "bindings";
            bindings = [
              {
                key = "f";
                name = "Find file";
                type = "command";
                command = "workbench.action.quickOpen";
              }
              {
                key = "g";
                name = "Find in files";
                type = "command";
                command = "workbench.action.findInFiles";
              }
              {
                key = "s";
                name = "Find symbol";
                type = "command";
                command = "workbench.action.gotoSymbol";
              }
            ];
          }
          {
            key = "b";
            name = "+buffer";
            type = "bindings";
            bindings = [
              {
                key = "b";
                name = "Switch buffer";
                type = "command";
                command = "workbench.action.showAllEditors";
              }
              {
                key = "d";
                name = "Close buffer";
                type = "command";
                command = "workbench.action.closeActiveEditor";
              }
            ];
          }
          {
            key = "w";
            name = "+window";
            type = "bindings";
            bindings = [
              {
                key = "v";
                name = "Split vertical";
                type = "command";
                command = "workbench.action.splitEditor";
              }
              {
                key = "s";
                name = "Split horizontal";
                type = "command";
                command = "workbench.action.splitEditorDown";
              }
              {
                key = "d";
                name = "Close window";
                type = "command";
                command = "workbench.action.closeEditorsInGroup";
              }
              {
                key = "h";
                name = "Focus left";
                type = "command";
                command = "workbench.action.focusLeftGroup";
              }
              {
                key = "l";
                name = "Focus right";
                type = "command";
                command = "workbench.action.focusRightGroup";
              }
              {
                key = "j";
                name = "Focus below";
                type = "command";
                command = "workbench.action.focusBelowGroup";
              }
              {
                key = "k";
                name = "Focus above";
                type = "command";
                command = "workbench.action.focusAboveGroup";
              }
            ];
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
      };
      keybindings = [
        # Trigger which-key with space in normal mode
        {
          key = "space";
          command = "whichkey.show";
          when = "editorTextFocus && vim.mode == 'Normal'";
        }
        # Git: <leader>gg for lazygit
        {
          key = "g";
          command = "whichkey.triggerKey";
          args = "g";
          when = "whichkeyVisible";
        }
        # Jujutsu: <leader>jj for jjui
        {
          key = "j";
          command = "whichkey.triggerKey";
          args = "j";
          when = "whichkeyVisible";
        }
        # Terminal toggle with <leader>t
        {
          key = "t";
          command = "whichkey.triggerKey";
          args = "t";
          when = "whichkeyVisible";
        }
        # Escape to close maximized terminal
        {
          key = "escape";
          command = "workbench.action.closePanel";
          when = "terminalFocus && isTerminalPaneOpen";
        }
      ];
    };
  };
}
