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
  # TODO: (Matei) add option to remove dev tooling EXCEPT DOOM EMACS from home-manager config.
  config = lib.mkIf cfg.enable {
    programs.claude-code = {
      enable = true;
      package = inputs.llm-agents.packages.${system}.claude-code;
      enableMcpIntegration = true;
    };
  };
}
