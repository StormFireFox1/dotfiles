{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.fireflake.programs;
  readAllNixFiles = (
    x: lib.filter (x: lib.strings.hasSuffix ".nix" x) (lib.filesystem.listFilesRecursive x)
  );
in
{
  imports = lib.lists.flatten [
    (readAllNixFiles ./base)
    (readAllNixFiles ./darwin)
    (readAllNixFiles ./linux)
    ./doom
    ./fish
  ];
  options.fireflake.programs = {
    darwin.enable = mkOption {
      type = types.bool;
      description = "Install programs specific for use in a macOS environment.";
      default = false;
    };
    wayland.enable = mkOption {
      type = types.bool;
      description = "Install programs specific for use in a Wayland desktop environment. These are evidently less useful on a MacBook.";
      default = false;
    };
    enable = mkEnableOption "Enables common programs.";
  };
  config = mkIf cfg.enable {
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
  };
}
