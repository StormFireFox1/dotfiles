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
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        theme = "catppuccin-macchiato";
      };
    };
  };
}
