{ lib, pkgs, ... }:
{
  programs.jjui = {
    enable = true;
    settings = {
      ui = {
        theme = "catppuccin-mocha";
      };
    };
  };

  xdg.configFile = {
    "jjui/themes/catppuccin-mocha.toml".source =
      let
        repo = pkgs.fetchFromGitHub {
          owner = "vic";
          repo = "tinted-jjui";
          rev = "b3db8568f2cd53f4cb457dea8042897f91386a1a";
          hash = "sha256-1EkpxSk/PnTjfc+9r8wnkLqMibJoVuOtaaMWJaowA9M=";
        };
      in
      "${repo}/themes/base24-catppuccin-mocha.toml";
  };
}
