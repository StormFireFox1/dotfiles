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
  };
}
