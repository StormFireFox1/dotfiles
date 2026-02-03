{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  personalNixCacheBuckets = {
    stormhub = "stormhub:XNNi+rfycudWZKjB1M31qfjOwz0YsGAgwNZa65vbpAs=";
    dotfiles = "dotfiles:7wa3AXQHghAeU6xxYRkQFxxYe2STmxpc83r2Bk5fbFk=";
  };
in
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
        substituters = builtins.attrNames personalNixCacheBuckets;
        trusted-public-keys = builtins.attrValues personalNixCacheBuckets;
        netrc-file = config.age.secrets.AtticCacheNetrc.path;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };
  };
  nixpkgs.config.allowUnfree = true;
}
