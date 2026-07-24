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
    programs.crush = {
      enable = true;
      package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.crush;
    };
  };
}
