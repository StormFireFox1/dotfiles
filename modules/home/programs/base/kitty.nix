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
  config = lib.mkIf cfg.enable {
    home.sessionVariables.TERMINAL = "kitty";
    programs.kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 10;
      };
      shellIntegration.enableFishIntegration = true;
      settings = {
        background_opacity = 0.9;
        shell = "fish";
        confirm_os_window_close = 0;
      };
    };
  };
}
