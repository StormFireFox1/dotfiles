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
    programs.claude-code = {
      enable = true;
      package = inputs.llm-agents.packages.${system}.claude-code;
      enableMcpIntegration = true;
    };
  };
}
