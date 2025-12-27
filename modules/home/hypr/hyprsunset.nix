{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.fireflake.hypr;
in
{
  config = lib.mkIf cfg.enable {
    services.hyprsunset = {
      enable = true;
      settings = {
        max-gamma = 150;
        profile = [
          {
            time = "7:30";
            identity = true;
          }
          {
            time = "21:00";
            temperature = 5000;
            gamma = 0.8;
          }
        ];
      };
    };
  };
}
