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
  config = lib.mkIf (cfg.enable && cfg.dev.enable) {
    programs.zed-editor = {
      enable = true;

      extraPackages = with pkgs; [
        nixd
        nil
      ];

      mutableUserSettings = false;
      mutableUserKeymaps = false;
      mutableUserTasks = false;
      mutableUserDebug = false;

      extensions = [
        "catppuccin"
        "catppuccin-icons"
        "nix"
        "zig"
        "terraform"
        "dockerfile"
        "docker-compose"
        "typst"
        "helm"
        "starlark"
        "editorconfig"
        "git-firefly"
        "jj-lsp"
      ];

      userSettings = {
        # Font
        "buffer_font_family" = "JetBrainsMono Nerd Font Mono";
        "buffer_font_size" = 14;
        "ui_font_family" = "JetBrainsMono Nerd Font Mono";
        "ui_font_size" = 14;

        # Editor
        "vim_mode" = true;
        "relative_line_numbers" = true;
        "cursor_blink" = false;
        "tab_size" = 2;
        "scrollbar" = {
          "show" = "never";
        };

        # Terminal
        "terminal" = {
          "shell" = {
            "program" = "fish";
          };
          "font_family" = "JetBrainsMono Nerd Font Mono";
          "font_size" = 14;
        };

        # Which-key
        "which_key" = {
          "enabled" = true;
        };

        # Nix LSP
        "languages" = {
          "Nix" = {
            "language_servers" = [
              "nixd"
              "!nil"
            ];
          };
        };

        # Telemetry
        "telemetry" = {
          "metrics" = false;
          "diagnostics" = false;
        };

        # AI!
        "features" = {
          "edit_predictions" = true;
        };
        "edit_predictions" = {
          "provider" = "open_ai_compatible_api";
          "open_ai_compatible_api" = {
            "api_url" = "https://openrouter.ai/api/v1";
            "model" = "z-ai/glm-5v-turbo";
            "prompt_format" = "glm";
            "max_output_tokens" = 64;
          };
        };
        "agent" = {
          "default_model" = {
            "provider" = "openrouter";
            "model" = "z-ai/glm-5v-turbo";
          };
        };
      };

      userKeymaps = [
        # Unbind space so it works as a leader key for which-key
        {
          context = "(VimControl && !menu)";
          bindings = {
            "space" = null;
          };
        }

        {
          "context" = "Editor && vim_mode == insert && edit_prediction";
          bindings = {
            "tab" = "editor::AcceptEditPrediction";
          };
        }

        # Leader key bindings (space-prefixed, mirroring VSpaceCode)
        {
          context = "Editor && vim_mode == normal && !menu";
          bindings = {
            # File
            "space space" = "file_finder::Toggle";
            "space f s" = "workspace::Save";
            "space f S" = "workspace::SaveAll";

            # Buffers
            "space b b" = "tab_switcher::Toggle";
            "space b d" = "pane::CloseActiveItem";
            "space b n" = "pane::ActivateNextItem";
            "space b p" = "pane::ActivatePrevItem";

            # Commands
            "space shift-k" = "command_palette::Toggle";

            # Search
            "space s p" = "pane::DeploySearch";
            "space s s" = "buffer_search::Deploy";

            # Windows / panes
            "space w v" = "pane::SplitRight";
            "space w s" = "pane::SplitDown";
            "space w d" = "pane::CloseActiveItem";
            "space w h" = "workspace::ActivatePaneLeft";
            "space w l" = "workspace::ActivatePaneRight";
            "space w j" = "workspace::ActivatePaneDown";
            "space w k" = "workspace::ActivatePaneUp";

            # Git
            "space g g" = "workspace::NewTerminal";
            "space g y" = "editor::CopyPermalinkToLine";
            "space g b" = "git::Blame";

            # Jujutsu
            "space j j" = "workspace::NewTerminal";

            # Open
            "space o t" = "workspace::NewTerminal";
            "space o e" = "project_panel::ToggleFocus";

            # Errors / diagnostics
            "space e e" = "diagnostics::Deploy";
            "space e n" = "editor::GoToDiagnostic";
            "space e p" = "editor::GoToPrevDiagnostic";

            # Code actions
            "space c a" = "editor::ToggleCodeActions";
            "space c r" = "editor::Rename";
            "space c f" = "editor::Format";

            # K for hover info (like VSCode)
            "shift-k" = "editor::Hover";
          };
        }

        # Visual mode leader bindings
        {
          context = "Editor && vim_mode == visual && !menu";
          bindings = {
            "space space" = "file_finder::Toggle";
            "space shift-k" = "command_palette::Toggle";
            ">" = "editor::Indent";
            "<" = "editor::Outdent";
          };
        }

        # Ctrl+j/k navigation in pickers (like VSCode quickOpen)
        {
          context = "Picker > Editor";
          bindings = {
            "ctrl-j" = "menu::SelectNext";
            "ctrl-k" = "menu::SelectPrev";
            "ctrl-l" = "menu::Confirm";
          };
        }
      ];

      userTasks = [
        {
          label = "Lazygit";
          command = "lazygit";
          use_new_terminal = true;
          reveal = "always";
        }
        {
          label = "jjui";
          command = "jjui";
          use_new_terminal = true;
          reveal = "always";
        }
      ];
    };
  };
}
