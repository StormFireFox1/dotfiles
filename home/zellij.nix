{ lib, pkgs, ... }:
{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      theme = "catppuccin-macchiato";
    };
  };
}
