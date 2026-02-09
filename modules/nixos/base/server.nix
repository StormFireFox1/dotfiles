{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.fireflake.nixos.type == "server") {
    # Server-specific: no GUI, no display manager
    services.xserver.enable = lib.mkDefault false;

    environment.systemPackages = with pkgs; [
      tcpdump
    ];
  };
}
