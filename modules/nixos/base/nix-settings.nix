{ lib, ... }:
{
  config = {
    nix = {
      gc = {
        automatic = true;
        persistent = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      settings = {
        trusted-users = [
          "root"
          "@wheel"
        ];
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
    };
    nixpkgs.config.allowUnfree = true;
  };
}
