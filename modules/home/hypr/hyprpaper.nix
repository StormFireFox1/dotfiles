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
  config = lib.mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        preload = [
          # TODO: Make this more general? i.e. iterate over ./wallpapers
          "${config.xdg.configHome}/hypr/wallpapers/Mountain.png"
          "${config.xdg.configHome}/hypr/wallpapers/Boat.png"
        ];
        wallpaper = [
          "DP-3,${config.xdg.configHome}/hypr/wallpapers/Mountain.png"
          "HDMI-A-2,${config.xdg.configHome}/hypr/wallpapers/Boat.png"
          ",${config.xdg.configHome}/hypr/wallpapers/Mountain.png"
        ];
      };
    };

    xdg.configFile."hypr/wallpapers" = {
      source = ./wallpapers;
      recursive = true;
    };
  };
}
