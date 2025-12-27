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
    programs.hyprlock = {
      enable = true;
      package = inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock;
      settings = {
        background = [
          {
            monitor = "DP-3";
            path = "screenshot";
            blur_passes = 2;
          }
          {
            monitor = "HDMI-A-2";
            path = "screenshot";
            blur_passes = 2;
          }
        ];

        image = {
          monitor = "HDMI-A-2";
          size = "300";
          path = "${config.xdg.configHome}/hypr/pictures/Profile.png";
          position = "0, 300";
          halign = "center";
          valign = "center";
          rounding = 0;
          border_size = 0;
        };

        label = [
          {
            monitor = "HDMI-A-2";
            text = "$TIME";
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 95;
            font_family = "JetBrains Mono";
            position = "0, 100";
            halign = "center";
            valign = "center";
          }
          {

            monitor = "HDMI-A-2";
            text = ''cmd[update:1000] echo $(date +"%A, %B %d")'';
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 22;
            font_family = "JetBrains Mono";
            position = "0, 0";
            halign = "center";
            valign = "center";

          }
        ];

        input-field = {
          monitor = "HDMI-A-2";
          size = "200,50";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.35;
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(0, 0, 0, 0.2)";
          font_color = "rgb(243, 139, 168)";
          fade_on_empty = false;
          rounding = -1;
          check_color = "rgb(30, 107, 204)";
          placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
          hide_input = false;
          position = "0, -100";
          halign = "center";
          valign = "center";
        };

        general = {
          auth_method = "pam";
        };
      };
    };

    xdg.configFile."hypr/pictures" = {
      source = ./pictures;
      recursive = true;
    };
  };
}
