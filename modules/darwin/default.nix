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
      trusted-substituters = [
        "s3://nix?endpoint=s3.matei.lol&scheme=https&region=us-west-1"
      ];
      trusted-public-keys = [
        "cache.nix.matei.lol-1:0WG5OX49ly+JBwkuu0P+tLDcWZC1oWPmiowZgcl+p+k="
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
    colima
    docker
  ];

  environment = {
    systemPath = [
      "/opt/homebrew/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };
  programs.fish.enable = true;
}
