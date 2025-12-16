{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      nerd-fonts.symbols-only
      emacs-lsp-booster
      uutils-findutils
      uutils-diffutils
      uutils-coreutils-noprefix
      dua
      dust
      gitnr
      hyperfine
      xh
      python3
      nil
      jq
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
