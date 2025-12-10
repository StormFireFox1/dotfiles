{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello
    ];

    username = "ghost";
    homeDirectory = "/home/ghost";

    stateVersion = "25.05";
  };
}
