{ lib, pkgs, ... }:
{
  programs.doom-emacs = {
    enable = true;
    doomDir = ./config;
    extraPackages = epkgs: [
      epkgs.treesit-grammars.with-all-grammars
    ];
  };
}
