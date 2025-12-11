{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      uutils-findutils
      uutils-diffutils
      uutils-coreutils-noprefix
    ];

    username = "ghost";
    homeDirectory = "/home/ghost";

    stateVersion = "25.05";
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      vim = "nvim";
    };
  };
  programs.nushell.enable = true;
  programs.zsh.enable = true;
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;
  };
}
