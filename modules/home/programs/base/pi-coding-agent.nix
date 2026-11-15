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
    programs.pi-coding-agent = {
      enable = true;
      package = inputs.llm-agents.packages.${system}.pi;
    };

    home.packages = [ inputs.llm-agents.packages.${system}.omp ];
  };
}
