{
  lib,
  pkgs,
  config,
  ...
}:
{
  networking.hostName = "StormPrism";

  homebrew.casks = [
    "discord"
    "slack"
  ];

  environment.systemPackages = with pkgs; [
    nh
  ];
}
