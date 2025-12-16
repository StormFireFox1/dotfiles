{
  lib,
  pkgs,
  config,
  home,
  ...
}:
{
  age.secrets.BorgBackupKey = {
    file = ../secrets/BorgBackupKey.age;
    path = "${config.home.homeDirectory}/.config/borgmatic.d/key";
  };
  services.borgmatic = {
    enable = true;
  };
  programs.borgmatic = {
    enable = true;
    backups = {
      home = {
        consistency = {
          checks = [
            {
              name = "repository";
              frequency = "2 weeks";
            }
            {
              name = "archives";
              frequency = "4 weeks";
            }
            {
              name = "data";
              frequency = "6 weeks";
            }
            {
              name = "extract";
              frequency = "6 weeks";
            }
          ];
        };
        location = {
          patterns = [
            "R /home/ghost"
            "- /home/ghost/.cache"
            "- /home/ghost/.local/share/Steam"
            "- /home/ghost/Downloads"
          ];
          repositories = [
            {
              path = "ssh://borg@stormdrive.bobcat-gopher.ts.net:31187/volume1/Backups/BullshitMachine";
              label = "StormDrive";
            }
          ];
          excludeHomeManagerSymlinks = true;
        };
        storage = {
          extraConfig = {
            compression = "auto,zstd";
            ssh_command = "ssh -i /home/ghost/.ssh/id_ed25519";
            remote_path = "/usr/local/bin/borg";
            encryption_passphrase = "{credential file ${config.home.homeDirectory}/.config/borgmatic.d/key}";
          };
        };
        retention = {
          keepHourly = 3;
          keepDaily = 7;
          keepMonthly = 6;
          keepYearly = 2;
        };
      };
    };
  };
}
