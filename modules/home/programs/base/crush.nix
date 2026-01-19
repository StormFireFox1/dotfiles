{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.fireflake.programs;
  system = pkgs.stdenv.hostPlatform.system;
in
{
  config = lib.mkIf cfg.enable {
    programs.crush = {
      enable = true;
      package = inputs.llm-agents.packages.${system}.crush;
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
