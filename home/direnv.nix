{ lib, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
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
