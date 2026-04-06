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
    ../misc/ssh-keys.nix
    ./homebrew.nix
    ./settings.nix
    ./aerospace.nix
  ];
  nix = {
    linux-builder = {
      enable = true;
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      config = (
        { pkgs, ... }:
        {
          boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
        }
      );
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    settings = {
      trusted-users = [
        "ghost"
        "root"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    enable = true;
    package = pkgs.lix;
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
    openssh.authorizedKeys.keys = config.fireflake.sshKeys;
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

  environment.systemPackages = with pkgs; [
    podman
    qemu
  ];
}
