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

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    vollkorn
    fira-code
    jetbrains-mono
  ];

  environment = {
    systemPath = [
      "/opt/homebrew/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };
  programs.fish.enable = true;
}
