{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.fireflake.programs;
in
{
  config = lib.mkIf cfg.enable {
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
          diff-editor = ":builtin";
          diff-formatter = ":git";
        };
        git = {
          sign-on-push = true;
        };
        colors = {
          "diff removed token" = { fg = "bright red"; bg = "#400000"; underline = false; };
          "diff added token" = { fg = "bright green"; bg = "#003000"; underline = false; };
        };
        aliases = {
          tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-"];
          rebase-all = ["rebase" "-s" "roots(trunk()..mutable())" "-d" "trunk()"];
        };
      };
    };
  };
}
