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
  driveFolders = [
    "Dumps"
    "Backups"
    "Media"
    "Steam"
  ];
  mounts = map (x: "/mnt/StormDrive/" + x) driveFolders;
in
{
  config = lib.mkIf (cfg.type == "desktop") {
    systemd.tmpfiles.rules = map (x: "d " + x + " 0755 ghost users -") mounts;
    # Mount all local folders that are exposed by StormDrive.
    # These are all on the local network.
    fileSystems = lib.attrsets.genAttrs mounts (mount: {
      device = "//StormDrive.local/" + builtins.baseNameOf mount;
      fsType = "cifs";
      options =
        let
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        in
        [ "${automount_opts},credentials=${config.age.secrets.StormDriveSmbKey.path},uid=1000,gid=100" ];
    });
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };
    environment.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
    services.ratbagd.enable = true;
    environment.systemPackages = with pkgs; [
      cifs-utils
      piper
      winetricks
      wineWowPackages.stable
      wineWowPackages.staging
      yabridge
      yabridgectl
    ];
  };
}
