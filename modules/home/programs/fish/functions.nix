# Fish functions.
#
# All Fish functions are available in "fish/functions" without
# their wrapper bodies. The metadata surrounding the wrapper
# is in this file.
#
# This file returns an attrset, where the structure is:
# {
#   fish_function_1 = {};
#   fish_function_2 = {
#     description = "This function does something".
#   };
#
#   The required "body" parameter is pulled from the files automatically
#   by this file.
# }
{ lib, pkgs, config, ... }:
let
  inherit (lib) isAttrs attrsets.mapAttrs;
  add_body_to_function_set =  function_name: function_set: lib.attrsets.overrideExisting function_set { body = builtins.readFile ( lib.path.append ./functions "/${function_name}.fish"); };
in
  mapAttrs add_body_to_function_set
  {
    find-repo-and-open = {
      description = "Opens a NeoVim window on the selected repo.";
    };
    find-repo-and-open-code = {
      description = "Opens a VSCode window on the selected repo.";
    };
    find-repo = {
      description = "cd's to the selected repo.";
    };
    replace-history = {
      description = "Returns the last item in the history of the shell.";
    };
    select-repo = {
      description = "Fuzzy searched for Git repos under ~/Repos and returns the selected path.";
    };
    slides = {
      description = "Opens a Presenterm from the main Obsidian vault.";
    };
  }