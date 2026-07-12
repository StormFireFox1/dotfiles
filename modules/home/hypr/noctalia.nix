{
  config,
  lib,
  ...
}:
let
  cfg = config.fireflake.hypr;
in
{
  config = lib.mkIf (cfg.enable && cfg.shellType == "noctalia") {
    programs.noctalia = {
      enable = true;
      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        wallpaper = {
          enabled = true;
          directory = "${config.xdg.configHome}/hypr/wallpapers";
          default.path = "${config.xdg.configHome}/hypr/wallpapers/Mountain.png";
          per_monitor_directories = true;
          automation = {
            enabled = true;
            interval_seconds = 3600;
            order = "random";
            recursive = true;
          };
        };

        location = {
          auto_locate = true;
        };

        nightlight = {
          enabled = true;
        };

        calendar = {
          enabled = true;
          refresh_minutes = 15;
          account = {
            fastmail = {
              type = "caldav";
              name = "Fastmail Personal";
              provider = "custom";
              server_url = "https://caldav.fastmail.com/dav/principals/user/storm_firefox1@fastmail.com/";
              username = "storm_firefox1@fastmail.com";
            };
          };
        };

        widget = {
          clock = {
            format = "{:%A, %Y-%m-%d, %H:%M:%S}";
          };
        };

        shell = {
          avatar_path = "${config.xdg.configHome}/hypr/pictures/Profile.png";
          date_format = "%A, %Y-%m-%d";
          time_format = "{:%H:%M:%S}";
          polkit_agent = true;
          screenshot = {
            confirm_region = true;
            directory = "${config.home.homeDirectory}/Pictures/Screenshots";
            filename_pattern = "screenshot_%Y-%m-%d-%H-%M-%S";
          };
        };

        lockscreen = {
          blurred_desktop = true;
        };

        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;

          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = false;
          };

          widget = {
            disabled_password_box = {
              type = "login_box";
              output = "DP-4";
              enabled = false;
            };
            password_box = {
              box_height = 64.0;
              box_width = 512.0;
              cx = 1280.0;
              cy = 944.0;
              output = "DP-3";
              rotation = 0.0;
              type = "login_box";

              settings = {
                background_color = "surface_variant";
                background_opacity = 0.88;
                background_radius = 12.0;
                input_opacity = 1.0;
                input_radius = 12.0;
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_password_hint = true;
              };
            };

            date = {
              box_height = 64.0;
              box_width = 640.0;
              cx = 1280.0;
              cy = 752.0;
              output = "DP-3";
              rotation = 0.0;
              type = "clock";

              settings = {
                background = false;
                format = "{:%A, %e %B %Y}";
              };
            };

            time = {
              box_height = 128.0;
              box_width = 384.0;
              cx = 1280.0;
              cy = 848.0;
              output = "DP-3";
              rotation = 0.0;
              type = "clock";

              settings = {
                background = false;
                format = "{:%H:%M:%S}";
              };
            };

            weather = {
              box_height = 128.0;
              box_width = 256.0;
              cx = 1280.0;
              cy = 1296.0;
              output = "DP-3";
              rotation = 0.0;
              type = "weather";

              settings = {
                background = false;
              };
            };

            audio = {
              box_height = 208.0;
              box_width = 736.0;
              cx = 320.0;
              cy = 1336.0;
              output = "DP-3";
              rotation = 0.0;
              type = "audio_visualizer";

              settings = {
                background = false;
                bands = 96;
                centered = false;
                color_2 = "secondary";
                mirrored = false;
                show_when_idle = true;
              };
            };

            profile_image = {
              box_height = 384.0;
              box_width = 656.0;
              cx = 1280.0;
              cy = 592.0;
              output = "DP-3";
              rotation = 0.0;
              type = "sticker";

              settings = {
                background = false;
                background_opacity = 0.05;
                background_padding = 0;
                background_radius = 32;
                image_path = "${config.xdg.configHome}/hypr/pictures/Profile.png";
                opacity = 1.0;
              };
            };
          };
        };
      };
    };
  };
}
