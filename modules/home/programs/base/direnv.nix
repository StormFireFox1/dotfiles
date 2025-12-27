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
    programs.direnv = {
      enable = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      mise = {
        enable = true;
      };
      nix-direnv = {
        enable = true;
      };
    };
  };
}
