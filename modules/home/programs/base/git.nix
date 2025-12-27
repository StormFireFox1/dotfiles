{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.fireflake.programs;
in
{
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Matei-Alexandru Gardus";
          email = "matei@gard.us";
          signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub"; # TODO: Replace this with Agenix secret.
        };
        gpg = {
          format = "ssh";
        };
        commit = {
          gpgsign = "true";
        };
      };
    };
  };
}
