{ lib, pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    plugins =
      with pkgs.yaziPlugins;
      lib.genAttrs [
        "yatline"
        "yatline-catppuccin"
        "sudo"
        "duckdb"
        "git"
        "lazygit"
        "mount"
        "ouch"
        "piper"
        "recycle-bin"
        "restore"
        "rich-preview"
        "starship"
        "wl-clipboard"
      ] (pluginName: builtins.getAttr pluginName pkgs.yaziPlugins);
  };
}
