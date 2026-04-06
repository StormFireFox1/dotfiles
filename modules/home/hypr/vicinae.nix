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
  config = lib.mkIf cfg.enable {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
    };
  };
}
