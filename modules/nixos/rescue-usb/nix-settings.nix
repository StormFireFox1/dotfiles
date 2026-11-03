{
  lib,
  ...
}:
{
  nix.settings = {
    trusted-users = lib.mkForce [
      "ghost"
      "nixos"
    ];
  };
}
