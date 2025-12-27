{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.fireflake.hypr;
in
{
  programs.ashell = {
    enable = cfg.enable;
    settings = {
      appearance = {
        success_color = "#a6e3a1";
        text_color = "#cdd6f4";
        workspace_colors = [
          "#f38ba8"
          "#fab387"
          "#f9e2af"
        ];
        primary_color = {
          base = "#f38ba8";
          text = "#1e1e2e";
        };
        danger_color = {
          base = "#f38ba8";
          weak = "#f9e2af";
        };
        background_color = {
          base = "#1e1e2e";
          weak = "#313244";
          strong = "#45475a";
        };
        secondary_color = {
          base = "#11111b";
          strong = "#1b1b25";
        };
      };
      modules = {
        center = [
          "WindowTitle"
        ];
        left = [
          "Workspaces"
        ];
        right = [
          "Media Player"
          "Tray"
          "SystemInfo"
          [
            "Clock"
            "Privacy"
            "Settings"
          ]
        ];
      };
      workspaces = {
        visibility_mode = "MonitorSpecific";
      };
      keyboard_layout = {
        labels = {
          "English (US)" = "🇺🇸";
          "Romanian" = "🇷🇴";
        };
      };
      system_info = {
        indicators = [
          "Cpu"
          "Memory"
          { Disk = "/"; }
          "Temperature"
        ];
        cpu = {
          warn_threshold = 60;
          alert_threshold = 80;
        };

        memory = {
          warn_threshold = 70;
          alert_threshold = 85;
        };

        disk = {
          warn_threshold = 80;
          alert_threshold = 90;
        };

        temperature = {
          warn_threshold = 60;
          alert_threshold = 80;
        };
      };
    };
  };
}
