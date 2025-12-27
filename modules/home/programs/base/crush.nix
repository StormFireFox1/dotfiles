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
    programs.crush = {
      enable = true;
      settings = {
        lsp = {
          go = {
            command = "gopls";
            enabled = true;
          };
          nix = {
            command = "nil";
            enabled = true;
          };
        };
        options = {
          tui = {
            compact_mode = true;
          };
        };
      };
    };
  };
}
