{ lib, pkgs, ...}:
{
  services.flameshot = {
    enable = true;
    settings = {
      useGrimAdapter = true;
    };
  };
}
