{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.fireflake.programs;
  hotkey = id: binding: { inherit id binding; };
  unassignedHotkey = id: hotkey id "Unassigned";
  unassignedNumberedHotkeys =
    action: first: last:
    map (number: unassignedHotkey "${action}.${toString number}") (lib.range first last);

  # Zero-based numbered hotkeys (switchWorkspace.N, moveToWorkspace.N, focusColumn.N).
  numberedHotkeys =
    action: bindings: lib.imap0 (index: binding: hotkey "${action}.${toString index}" binding) bindings;

  # Directional chords for h/j/k/l so navigation matches Vim motion keys instead
  # of the arrow keys OmniWM ships by default.
  direction = {
    left = "H";
    down = "J";
    up = "K";
    right = "L";
  };

  workspaceBinding = modifier: number: "${modifier}+${toString (number + 1)}";
  columnBinding = modifier: number: "${modifier}+${toString (number + 1)}";
in
{
  config = lib.mkIf (cfg.enable && cfg.darwin.enable) {
    xdg.configFile."omniwm/settings.toml" = {
      force = true;
      source = (pkgs.formats.toml { }).generate "omniwm-settings.toml" {
        appearance = {
          mode = "dark";
          tabRailAppIcons = false;
        };
        borders = {
          enabled = true;
          width = 2.0;
          # Muted, darker blue instead of OmniWM's intense cyan accent.
          color = {
            red = 0.14;
            green = 0.29;
            blue = 0.52;
            alpha = 1.0;
          };
          darkColor = {
            red = 0.14;
            green = 0.29;
            blue = 0.52;
            alpha = 1.0;
          };
        };
        clipboard = {
          historyEnabled = false;
        };
        gaps = {
          # Keep a 4px gap even for fullscreen frames.
          fullscreenUsesOuterGaps = true;
          size = 16.0;
          outer = {
            left = 4.0;
            right = 4.0;
            top = 4.0;
            bottom = 4.0;
          };
        };
        general = {
          animationSpeed = 1.0;
          animationsEnabled = true;
          defaultLayoutType = "niri";
          hotkeysEnabled = true;
          hyperKeyModifiers = "Control+Option+Shift+Command";
          ipcEnabled = false;
          preventSleepEnabled = false;
          systemHyperTrigger = "None";
          updateChecksEnabled = true;
        };
        hiddenBar = {
          enabled = true;
          hiddenBundleIDs = [ ];
          rehideIntervalSeconds = 5.0;
        };

        # OmniWM resolves this list strictly: any action that is not listed here
        # becomes "Unassigned". Every binding OmniWM ships by default is therefore
        # repeated below, with the arrow-key chords remapped to h/j/k/l.
        hotkeys = [
          # Directional focus: Option + h/j/k/l.
          (hotkey "focus.left" "Option+${direction.left}")
          (hotkey "focus.down" "Option+${direction.down}")
          (hotkey "focus.up" "Option+${direction.up}")
          (hotkey "focus.right" "Option+${direction.right}")
          (hotkey "focusPrevious" "Option+Tab")

          # Directional window move: Option + Shift + h/j/k/l.
          (hotkey "move.left" "Option+Shift+${direction.left}")
          (hotkey "move.down" "Option+Shift+${direction.down}")
          (hotkey "move.up" "Option+Shift+${direction.up}")
          (hotkey "move.right" "Option+Shift+${direction.right}")

          # Window between workspaces: Control + Option + Shift + j/k.
          (hotkey "moveWindowToWorkspaceUp" "Control+Option+Shift+${direction.up}")
          (hotkey "moveWindowToWorkspaceDown" "Control+Option+Shift+${direction.down}")
          (hotkey "moveColumnToWorkspaceUp" "Control+Option+Shift+Page Up")
          (hotkey "moveColumnToWorkspaceDown" "Control+Option+Shift+Page Down")

          (hotkey "workspaceBackAndForth" "Control+Option+Tab")

          # Columns: Control + Option + Shift + h/l.
          (hotkey "moveColumn.left" "Control+Option+Shift+${direction.left}")
          (hotkey "moveColumn.right" "Control+Option+Shift+${direction.right}")
          (hotkey "moveColumnToFirst" "Control+Option+Home")
          (hotkey "moveColumnToLast" "Control+Option+End")
          (hotkey "toggleColumnTabbed" "Option+T")
          (hotkey "focusColumnFirst" "Option+Home")
          (hotkey "focusColumnLast" "Option+End")

          # Monitors.
          (hotkey "focusMonitorNext" "Control+Command+Tab")
          (hotkey "focusMonitorLast" "Control+Command+`")

          # Sizing.
          (hotkey "cycleSizeForward" "Option+Period")
          (hotkey "cycleSizeBackward" "Option+Comma")
          (hotkey "toggleContainerFullPrimarySpan" "Option+Shift+F")
          (hotkey "expandContainerToAvailablePrimarySpan" "Control+Option+F")
          (hotkey "resetWindowSecondarySpan" "Control+Option+R")
          (hotkey "resizeContainerPrimarySpan.shrink" "Option+Minus")
          (hotkey "resizeContainerPrimarySpan.grow" "Option+Equal")
          (hotkey "resizeWindowSecondarySpan.shrink" "Option+Shift+Minus")
          (hotkey "resizeWindowSecondarySpan.grow" "Option+Shift+Equal")
          (hotkey "balanceSizes" "Option+Shift+B")

          # Presentation.
          (hotkey "openCommandPalette" "Control+Option+Space")
          (hotkey "raiseAllFloatingWindows" "Option+Shift+R")
          (hotkey "openMenuAnywhere" "Control+Option+M")
          # Moved off Option+Shift+L so it no longer collides with move.right.
          (hotkey "toggleWorkspaceLayout" "Option+Shift+T")
          (hotkey "toggleOverview" "Option+Shift+O")
          (hotkey "toggleQuakeTerminal" "Option+`")

          # Option+Enter launches Ghostty instead of OmniWM's fullscreen toggle.
          (hotkey "openApp.com.mitchellh.ghostty" "Option+Return")
        ]
        ++ numberedHotkeys "switchWorkspace" (map (workspaceBinding "Option") (lib.range 0 8))
        ++ numberedHotkeys "moveToWorkspace" (map (workspaceBinding "Option+Shift") (lib.range 0 8))
        ++ numberedHotkeys "focusColumn" (map (columnBinding "Control+Option") (lib.range 0 8));
        mouseWarp = {
          enabled = true;
        };
        niri = {
          edgeGaps = true;
          infiniteLoop = false;
        };
        overview = {
          enabled = true;
          invertScrollDirection = false;
          matchFocusBorder = true;
          mouseScrollSpeed = 1.0;
          zoom = 1.0;
        };
        quakeTerminal = {
          enabled = true;
          opacity = 0.9;
          position = "center";
        };
        routing = {
          arrangements = [ ];
          mode = "macOS";
        };
        scratchpads.labels = { };
        statusBar = {
          showIcon = true;
        };
        workspaceBar = {
          enabled = true;
          height = 24.0;
          notchMode = "moveBelowMenuBar";
          showItemBackgrounds = true;
          showLabels = true;
        };

        # The first five workspaces use the main display; the rest use the secondary.
        workspaces =
          lib.imap1
            (
              index: workspace:
              {
                inherit (workspace) id;
                name = toString index;
                layoutType = "niri";
                monitorAssignment.type = if index <= 5 then "main" else "secondary";
              }
              // lib.optionalAttrs (workspace ? displayName) {
                inherit (workspace) displayName;
              }
            )
            [
              { id = "AD36F001-C57E-41A5-AC1D-DF5249D007F0"; }
              { id = "454CECD4-5E9D-4ED1-95D7-979D48817F5F"; }
              { id = "BEB842B5-E894-4791-9FD1-397C3CDD3538"; }
              { id = "248AA883-2261-4D45-943C-79C0E46A232B"; }
              { id = "8B8C45D6-CE9E-41D9-BD50-BE4989D5E3DE"; }
              { id = "5953F2BF-A378-4266-91B2-287174C4FA4D"; }
              { id = "A7D5E104-6985-4516-8ED5-07F144F2A33D"; }
              { id = "0E18F6B0-345A-4078-8B21-33641F07A861"; }
              { id = "8D4D711C-2B2F-4FEC-86BF-FA952037738A"; }
              { id = "9EC69961-E131-4FC1-A652-9C1494854CA4"; }
            ];
      };
    };
    launchd.agents.omniwm = {
      enable = true;
      config = {
        Program = "/Applications/OmniWM.app/Contents/MacOS/OmniWM";
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/omniwm.log";
        StandardErrorPath = "/tmp/omniwm.err.log";
      };
    };
  };
}
