{ lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Matei-Alexandru Gardus";
        email = "matei@gard.us";
        signingkey = "/home/ghost/.ssh/id_ed25519.pub"; # TODO: Replace this with Agenix secret.
      };
      gpg = {
        format = "ssh";
      };
      commit = {
        gpgsign = "true";
      };
    };
  };
}
