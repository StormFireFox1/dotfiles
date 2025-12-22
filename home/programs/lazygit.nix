{ lib, pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };
}
