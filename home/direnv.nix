{ lib, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    mise = {
      enable = true;
    };
    nix-direnv = {
      enable = true;
    };
  };
}
