{
  lib,
  pkgs,
  config,
  ...
}:
let
  primaryUser = "ghost";
in
{
  imports = [
    ./homebrew.nix
    ./settings.nix
    ./aerospace.nix
  ];
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    enable = false;
  };

  nix-homebrew = {
    user = primaryUser;
    enable = true;
    autoMigrate = true;
  };

  system.primaryUser = primaryUser;
  users.users.${primaryUser} = {
    home = "/Users/${primaryUser}";
    shell = pkgs.zsh;
  };

  environment = {
    systemPath = [
      "/opt/homebrew/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };
  programs.fish.enable = true;
}
