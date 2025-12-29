{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.fireflake.hypr;
in
{
  imports = [
    ./ashell.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprshell.nix
    ./hyprsunset.nix
  ];

  options = {
    fireflake.hypr = {
      enable = mkEnableOption "Enables the Hyprland environment. Should only be enabled on Linux.";
    };
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      colorScheme = "dark";
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Bibata Modern Classic";
        package = pkgs.bibata-cursors;
      };
    };
  };
}
