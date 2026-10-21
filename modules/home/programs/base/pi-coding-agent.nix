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

    # oh-my-pi (OMP), a terminal-based coding agent with multi-model
    # support (https://github.com/can1357/oh-my-pi). home-manager has no
    # dedicated module for it, so it's just installed as a plain package.
    home.packages = [ inputs.llm-agents.packages.${system}.omp ];
  };
}
