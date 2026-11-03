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
      # The niks3 read path is public; see modules/nixos/base/nix-settings.nix
      # for the netrc note if reads are ever gated.
      substituters = lib.mkForce [
        "https://cache.nix.matei.lol"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = lib.mkForce [
        "cache.nix.matei.lol-1:wBgfuge7RLqU6NL/j0b4WNNVDEs4432eIQSODcSQJas="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      trusted-substituters = [ "https://cache.nix.matei.lol" ];
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
