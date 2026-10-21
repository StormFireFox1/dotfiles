{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.fireflake.hypr;
  types = lib.types;
in
{
  imports = [
    ./ashell.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprsunset.nix
    ./noctalia.nix
    ./vicinae.nix
  ];

  options = {
    fireflake.hypr = {
      enable = lib.mkEnableOption "Enables the Hyprland environment. Should only be enabled on Linux.";
      shellType = lib.mkOption {
        type = types.enum [
          "hypr"
          "noctalia"
        ];
        default = "hypr";
        example = "noctalia";
        description = "The desktop shell type to use. 'hypr' installs Hyprlock, Hypridle, Hyprpaper, Ashell and Hyprsunset. 'noctalia' uses the Noctalia shell configuration. This may become the default in the future.";
      };
      mainMonitor = lib.mkOption {
        type = types.str;
        default = "desc:Acer Technologies VG271U M3 3317055E63LAH";
        example = "DP-3";
        description = "The output identifier (or 'desc:<monitor description>' as reported by `hyprctl monitors all`) of the main monitor, placed to the right of the left monitor.";
      };
      leftMonitor = lib.mkOption {
        type = types.str;
        default = "desc:LG Electronics 27GL850 006NTYT3J042";
        example = "DP-4";
        description = "The output identifier (or 'desc:<monitor description>' as reported by `hyprctl monitors all`) of the left monitor.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kdePackages.dolphin
      hyprshutdown
    ];
    gtk = {
      enable = true;
      colorScheme = "dark";
      cursorTheme = {
        name = "Bibata Modern Classic";
        package = pkgs.bibata-cursors;
      };
    };
    xdg.configFile."hypr/wallpapers" = {
      source = ./wallpapers;
      recursive = true;
    };
    xdg.configFile."hypr/pictures/Profile.png" = {
      source = ./pictures/Profile.png;
    };
  };
}
