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
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      settings = {
        format = lib.concatStrings [
          "[](status_color)"
          "$os"
          "$shell"
          "$username"
          "[](bg:dir_color fg:status_color)"
          "$directory"
          "[](fg:dir_color bg:git_color)"
          "$git_branch"
          "$git_status"
          "[](fg:git_color bg:lang_color)"
          "$c"
          "$rust"
          "$golang"
          "$nodejs"
          "$php"
          "$java"
          "$kotlin"
          "$haskell"
          "$python"
          "[](fg:lang_color bg:docker_color)"
          "$kubernetes"
          "[](fg:docker_color bg:time_color)"
          "$time"
          "[ ](fg:time_color)"
          "$line_break$character"
        ];
        palette = "catppuccin";
        palettes = {
          catppuccin = {
            status_color = "#f38ba8";
            dir_color = "#fab387";
            git_color = "#a6e3a1";
            lang_color = "#585b70";
            docker_color = "#74c7ec";
            time_color = "#bac2de";
            text_color = "#313244";
            reverse_text_color = "#cdd6f4";
            red = "#f38ba8";
            green = "#a6e3a1";
            purple = "#cba6f7";
            yellow = "#f9e2af";
          };
          gruvbox_dark = {
            status_color = "#d64d0e";
            dir_color = "#d79921";
            git_color = "#689d6a";
            lang_color = "#665c54";
            docker_color = "#458588";
            time_color = "#3c3836";
            text_color = "#fbf1c7";
            reverse_text_color = "#fbf1c7";
            red = "#cc241d";
            green = "#98971a";
            purple = "#b16286";
            yellow = "#d79921";
          };
          dracula = {
            status_color = "#50fa7b";
            dir_color = "#bd93f9";
            git_color = "#8be9fd";
            lang_color = "#ffb86c";
            docker_color = "#f1fa8c";
            time_color = "#ff79c6";
            text_color = "#44475a";
            reverse_text_color = "#44475a";
            red = "#ff5555";
            green = "#50fa7b";
            purple = "#bd93f9";
            yellow = "#f1fa8c";
          };
        };
        os = {
          symbols = {
            Linux = "󰌽";
            Windows = "󰍲";
            Ubuntu = "󰕈";
            SUSE = "";
            Raspbian = "󰐿";
            Mint = "󰣭";
            Macos = "󰀵";
            Manjaro = "";
            Gentoo = "󰣨";
            Fedora = "󰣛";
            Alpine = "";
            Amazon = "";
            Android = "";
            Arch = "󰣇";
            Artix = "󰣇";
            CentOS = "";
            Debian = "󰣚";
            Redhat = "󱄛";
            RedHatEnterprise = "󱄛";
          };
          disabled = false;
          style = "bg:status_color fg:text_color";
        };
        shell = {
          disabled = false;
          format = "[ $indicator]($style)";
          style = "bg:status_color fg:text_color";
          fish_indicator = "󰈺 ";
          zsh_indicator = "%_ ";
          nu_indicator = "> ";
          bash_indicator = ">_ ";
          powershell_indicator = "󰨊 ";
        };
        username = {
          show_always = true;
          style_user = "bg:status_color fg:text_color";
          style_root = "bg:status_color fg:red";
          format = "[ $user ]($style)";
        };
        directory = {
          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = "󰝚 ";
            "Pictures" = " ";
            "Developer" = "󰲋 ";
          };
          style = "fg:text_color bg:dir_color";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
        };
        git_branch = {
          symbol = "";
          style = "bg:git_color";
          format = "[[ $symbol $branch ](fg:text_color bg:git_color)]($style)";
        };
        git_status = {
          style = "bg:git_color";
          format = "[[($all_status$ahead_behind )](fg:text_color bg:git_color)]($style)";
        };
        kubernetes = {
          symbol = " 󱃾";
          disabled = false;
          style = "bg:docker_color";
          format = "[[$symbol( $context) ](fg:text_color bg:docker_color)]($style)";
        };
        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:time_color";
          format = "[[  $time ](fg:text_color bg:time_color)]($style)";
        };
        line_break = {
          disabled = false;
        };
        character = {
          disabled = false;
          success_symbol = "[](bold fg:green)";
          error_symbol = "[](bold fg:red)";
          vimcmd_symbol = "[](bold fg:green)";
          vimcmd_replace_one_symbol = "[](bold fg:purple)";
          vimcmd_replace_symbol = "[](bold fg:purple)";
          vimcmd_visual_symbol = "[](bold fg:yellow)";
        };
      }
      //
        lib.attrsets.mapAttrs
          (langName: langSymbol: {
            symbol = langSymbol;
            style = "bg:lang_color";
            format = "[[ $symbol( $version) ](fg:reverse_text_color bg:lang_color)]($style)";
          })
          {
            nodejs = "";
            c = " ";
            rust = "";
            golang = "";
            php = "";
            java = " ";
            kotlin = "";
            haskell = "";
            python = "";
          };
    };
  };
}
