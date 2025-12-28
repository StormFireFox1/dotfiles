{
  lib,
  pkgs,
  config,
  home,
  ...
}:
with lib;
let
  cfg = config.fireflake.backup;
in
{
  options = {
    fireflake.backup = {
      enable = mkEnableOption "Enables backups to the personal StormDrive. You will have to assign the Borg repo name yourself, as well as run 'borg init' on it with the same password";
      repoName = mkOption {
        type = types.str;
        default = "BullshitMachine";
        description = "The name of the BorgBackup repo.";
      };
    };
  };
  config = mkIf cfg.enable {
    age.secrets.BorgBackupKey = {
      file = ../../../secrets/BorgBackupKey.age;
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
              "R ${config.home.homeDirectory}"
              "- ${config.home.homeDirectory}/.cache"
              "- ${config.home.homeDirectory}/.local/share/Steam"
              "- /home/ghost/Downloads"
            ];
            repositories = [
              {
                path = "ssh://borg@stormdrive.bobcat-gopher.ts.net:31187/volume1/Backups/${cfg.repoName}";
                label = "StormDrive";
              }
            ];
            excludeHomeManagerSymlinks = true;
          };
          storage = {
            extraConfig = {
              compression = "auto,zstd";
              ssh_command = "ssh -i ${config.home.homeDirectory}/.ssh/id_ed25519";
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

  };
}
