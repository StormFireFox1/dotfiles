{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
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
}
