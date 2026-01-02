{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.fireflake.hypr;
in
{
  config = lib.mkIf cfg.enable {
    programs.hyprshell = {
      enable = true;
      systemd.args = "-vv";
      settings = {
        windows = {
          enable = true;
          scale = 8.5;
          items_per_row = 5;
          switch.enable = true;
          overview = {
            enable = true;
            launcher = {
              default_terminal = "kitty";
              launch_modifier = "ctrl";
              width = 650;
              max_items = 5;
              show_when_empty = true;
              plugins = {
                applications = {
                  run_cache_weeks = 8;
                  show_execs = true;
                  show_actions_submenu = true;
                };
                terminal = { };
                shell = { };
                websearch = {
                  engines = [
                    {
                      url = "https://kagi.com/search?q={}";
                      name = "Kagi";
                      key = "k";
                    }
                    {
                      url = "https://www.google.com/search?q={}";
                      name = "Google";
                      key = "g";
                    }
                    {
                      url = "https://www.youtube.com/results?search_query={}";
                      name = "YouTube";
                      key = "y";
                    }
                  ];
                };
                calc = { };
                path = { };
                actions = {
                  actions = [
                    "lock_screen"
                    "hibernate"
                    "logout"
                    "reboot"
                    "shutdown"
                    "suspend"
                    {
                      custom = {
                        names = [
                          "Kill"
                          "Stop"
                        ];
                        details = "Kill or stop a process by name";
                        command = "pkill \"{}\" && notify-send hyprshell \"stopped {}\"";
                        icon = "remove";
                      };
                    }
                    {
                      custom = {
                        names = [ "Reload Hyprshell" ];
                        details = "Reload Hyprshell";
                        command = "sleep 1; hyprshell socat '\"Restart\"'";
                        icon = "system-restart";
                      };
                    }
                  ];
                };
              };
            };
            key = "space";
            modifier = "super";
            filter_by = [ ];
            hide_filtered = false;
          };
        };
      };
      styleFile = ./hyprshell/style.css;
    };
  };
}
