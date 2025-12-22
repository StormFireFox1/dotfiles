{ lib, pkgs, ... }:
{
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
}
