{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.fireflake.programs;
  types = lib.types;
in
{
  imports = [
    ./base/claude-code.nix
    ./base/crush.nix
    ./base/delta.nix
    ./base/direnv.nix
    ./base/fzf.nix
    ./base/gh.nix
    ./base/git.nix
    ./base/helix.nix
    ./base/jj.nix
    ./base/jjui.nix
    ./base/kitty.nix
    ./base/lazygit.nix
    ./base/ncspot.nix
    ./base/opencode.nix
    ./base/ssh.nix
    ./base/starship.nix
    ./base/vscode.nix
    ./base/yazi.nix
    ./base/zed.nix
    ./base/zellij.nix
    ./linux/flameshot.nix
    ./doom
    ./fish
  ];
  options.fireflake.programs = {
    darwin.enable = lib.mkOption {
      type = types.bool;
      description = "Install programs specific for use in a macOS environment.";
      default = false;
    };
    wayland.enable = lib.mkOption {
      type = types.bool;
      description = "Install programs specific for use in a Wayland desktop environment. These are evidently less useful on a MacBook.";
      default = false;
    };
    dev.enable = lib.mkOption {
      type = types.bool;
      description = "Enable programs needed for development, not basic shell functionality.";
      default = true;
    };
    enable = lib.mkEnableOption "Enables common programs.";
  };
  config = lib.mkIf cfg.enable {
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
    programs.zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
    };
    programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
