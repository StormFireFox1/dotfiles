{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      uutils-findutils
      uutils-diffutils
      uutils-coreutils-noprefix
      dua
      dust
      gitnr
      hyperfine
      xh
      python3
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
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellAliases = {
      vim = "nvim";
    };
  };
  programs.gh-dash.enable = true;
  programs.nushell.enable = true;
  programs.zsh.enable = true;
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
