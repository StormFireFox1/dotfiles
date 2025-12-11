{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      uutils-findutils
      uutils-diffutils
      uutils-coreutils-noprefix
      dua
      dust
      xh
    ];

    username = "ghost";
    homeDirectory = "/home/ghost";

    stateVersion = "25.05";
  };

  programs.bat.enable = true;
  programs.fd.enable = true;
  programs.ripgrep.enable = true;
  programs.bottom.enable = true;
  programs.eza = {
    enable = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
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
    enableZshIntegration = true;
  };
}
