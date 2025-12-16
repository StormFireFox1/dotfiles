{ lib, pkgs, ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Matei-Alexandru Gardus";
        email = "matei@gard.us";
      };
      signing = {
        behavior = "own";
        backend = "ssh";
        key = "~/.ssh/id_ed25519.pub";
      };
      ui = {
        paginate = "never";
	default-command = "log";
      };
      git = {
        sign-on-push = true;
      };
    };
  };
}
