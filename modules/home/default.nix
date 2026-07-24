{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.fireflake;
  isDarwin = pkgs.stdenv.isDarwin;
  types = lib.types;
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
    username = lib.mkOption {
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
        attic-client
        bun
        dua
        dust
        emacs-lsp-booster
        fastfetch
        gitnr
        hyperfine
        jq
        kubectl
        neovim
        nerd-fonts.symbols-only
        nil
        stu
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
    xdg.enable = true;
  };
}
