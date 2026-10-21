{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.fireflake.programs;
in
{
  config = lib.mkIf (cfg.enable && cfg.dev.enable) {
    # Disabled for now in favor of the Pi coding agent. Config left in place
    # so it can be flipped back on trivially.
    programs.claude-code = {
      enable = false;
      package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
      enableMcpIntegration = true;
    };
  };
}
