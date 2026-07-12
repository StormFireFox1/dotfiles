{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.fireflake.hypr;
in
{
  config = lib.mkIf (cfg.enable && cfg.shellType == "hypr") {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
    };
  };
}
