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
  config = lib.mkIf (cfg.enable && cfg.dev.enable) {
    programs.opencode = {
      enable = true;
      package = inputs.llm-agents.packages.${system}.opencode;
      enableMcpIntegration = true;
      settings = {
        theme = "catppuccin-macchiato";
      };
    };
  };
}
