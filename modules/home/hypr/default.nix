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
