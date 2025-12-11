{ lib, pkgs, ... }:
{
  catppuccin = {
    accent = "red";
    flavor = "mocha";
    bat.enable = true;
    eza.enable = true;
    fish.enable = true;
    fzf.enable = true;
    kitty.enable = true;
    lazygit.enable = true;
    nushell.enable = true;
    gh-dash.enable = true;
    thunderbird.enable = true;
    yazi.enable = true;
    zellij.enable = true;
  };
}
