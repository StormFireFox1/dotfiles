{ lib, pkgs, ... }:
{
  catppuccin = {
    accent = "red";
    flavor = "mocha";
    autoEnable = true;
    enable = true;
    bat.enable = true;
    eza.enable = true;
    delta.enable = true;
    fish.enable = true;
    fzf.enable = true;
    kitty.enable = true;
    lazygit.enable = true;
    nushell.enable = true;
    gh-dash.enable = true;
    thunderbird.enable = true;
    vicinae.enable = true;
    yazi.enable = true;
    zellij.enable = true;
    # Disabling color management for semi-custom configs.
    starship.enable = false;
    hyprland.enable = false;
  };
}
