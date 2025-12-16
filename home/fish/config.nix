{ lib, pkgs, ... }:
let
  fish_function_files = builtins.readDir ./functions;
  fish_functions = lib.attrsets.mapAttrs' (
    name: value:
    lib.attrsets.nameValuePair (lib.strings.removeSuffix ".fish" name) (
      builtins.readFile ./functions/${name}
    )
  ) fish_function_files;
in
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      set -gx EDITOR "nvim"
      set -gx SHELL "${pkgs.fish}/bin/fish"
    '';
    plugins =
      builtins.map
        (pluginName: {
          name = pluginName;
          src = builtins.getAttr pluginName pkgs.fishPlugins;
        })
        [
          "bass"
          "done"
          "fish-you-should-use"
          "sponge"
        ];
    functions = fish_functions;
    shellAliases = {
      vim = "nvim";
      cat = "bat";
    };
    shellAbbrs = {
      "!!" = {
        position = "anywhere";
        expansion = "replace-history";
      };
      "fr" = "find-repo";
      "fro" = "find-repo-and-open";
      "ka" = "kubectl apply";
      "kc" = "kubectl create";
      "kd" = "kubectl describe";
      "kg" = "kubectl get";
      "k@" = "kitty @";
      "k" = "kubectl";
      "kssh" = "kitten ssh";
      "savemp3" = "yt-dlp -f bestaudio -x --audio-format m4a";
      "saveyt" = "yt-dlp -f bestvideo+bestaudio --recode-video mp4";
      "tf" = "opentofu";
      "tg" = "terragrunt";
    };
  };
}
