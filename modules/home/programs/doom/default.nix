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
    programs.doom-emacs = {
      enable = true;
      doomDir = ./config;
      extraPackages = epkgs: [
        epkgs.treesit-grammars.with-all-grammars
      ];
    };
  };
}
