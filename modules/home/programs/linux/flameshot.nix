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
  config = lib.mkIf cfg.wayland.enable {
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          useGrimAdapter = true;
        };
      };
    };
  };
}
