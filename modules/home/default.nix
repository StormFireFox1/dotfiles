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
        _1password-cli
        adwaita-icon-theme
        claude-code
        dua
        dust
        emacs-lsp-booster
	fastfetch
        gitnr
        hyperfine
        jq
        neovim
        nerd-fonts.symbols-only
        nil
        python3
        uutils-coreutils-noprefix
        uutils-diffutils
        uutils-findutils
        xh
      ];

      username = cfg.username;
      homeDirectory = if isDarwin then "/Users/${cfg.username}" else "/home/${cfg.username}";
      stateVersion = "25.05";
      sessionPath = [
        "$HOME/.local/bin"
      ];
    };
    xdg = {
      enable = true;
    };
  };
}
