{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.fireflake.programs;
in
{
  config = lib.mkIf (cfg.enable && cfg.dev.enable) {
    home.sessionVariables.TERMINAL = "ghostty";
    programs.ghostty = {
      enable = true;
      # On macOS Ghostty is installed via Application bundle, not executable.
      package = if pkgs.stdenv.hostPlatform.isLinux then pkgs.ghostty else null;
      enableFishIntegration = true;
      settings = {
        command = "${pkgs.fish}/bin/fish";
        font-family = "JetBrainsMono Nerd Font";
        font-size = 16;
        background-opacity = "0.9";
        confirm-close-surface = false;
        shell-integration-features = "ssh-env,ssh-terminfo";
      };
    };
  };
}
