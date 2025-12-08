{ meta, ... }:
let
  secrets = {
    BullshitMachine = {
      StormDriveSmbKey = {
        owner = "root";
        group = "root";
      };
    };
  };
in
{
  age.secrets = builtins.listToAttrs (
    map (secretName: {
      name = secretName;
      value = {
        file = ../secrets/${secretName}.age;
      }
      // secrets."${meta.hostname}"."${secretName}";
    }) (builtins.attrNames secrets."${meta.hostname}")
  );
}
