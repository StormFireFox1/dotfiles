{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.fireflake.nixos.nix;
  types = lib.types;
  personalNixCacheBuckets = {
    "https://attic.nix.matei.lol/stormhub" = "stormhub:XNNi+rfycudWZKjB1M31qfjOwz0YsGAgwNZa65vbpAs=";
    "https://attic.nix.matei.lol/dotfiles" = "dotfiles:7wa3AXQHghAeU6xxYRkQFxxYe2STmxpc83r2Bk5fbFk=";
  };
in
{
  options.fireflake.nixos.nix = {
    pullAtticCaches = lib.mkOption {
      type = types.bool;
      description = "Whether to pull in Attic binary caches for Nix configuration. You will almost always need this.";
      default = true;
    };
  };
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
      }
      // lib.mkIf cfg.pullAtticCaches {
        substituters = builtins.attrNames personalNixCacheBuckets;
        trusted-public-keys = builtins.attrValues personalNixCacheBuckets;
        netrc-file = config.age.secrets.AtticCacheNetrc.path;
      };
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
    nixpkgs.config.allowUnfree = true;
  };
}
