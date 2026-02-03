{
  lib,
  pkgs,
  config,
  meta,
  inputs,
  ...
}:
let
  cfg = config.fireflake.nixos;
in
{
  config = lib.mkIf (cfg.type == "desktop" && cfg.desktop.dedicatedGraphicsType == "nvidia") {
    hardware.nvidia-container-toolkit.enable = true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
    };
  };
}
