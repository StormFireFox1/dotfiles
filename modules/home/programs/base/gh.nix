{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.fireflake.programs;
in
{
  config = lib.mkIf (cfg.enable && cfg.dev.enable) {
    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };
}
