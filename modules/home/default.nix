{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.fireflake;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  imports = [
    ./agenix.nix
    ./catppuccin.nix
    ./backup
    ./programs
    ./hypr
  ];
  options.fireflake = {
    username = mkOption {
      type = types.str;
      default = "ghost";
      description = "The username for the configuration.";
    };
  };
  config = {
    home = {
      packages = with pkgs; [
        claude-code
        nerd-fonts.symbols-only
        adwaita-icon-theme
        emacs-lsp-booster
        uutils-findutils
        uutils-diffutils
        uutils-coreutils-noprefix
        dua
        dust
        gitnr
        hyperfine
        xh
        python3
        nil
        jq
        neovim
      ];

      username = cfg.username;
      homeDirectory = if isDarwin then "/Users/${cfg.username}" else "/home/${cfg.username}";
      stateVersion = "25.05";
    };
    xdg = {
      enable = true;
    };
  };
}
