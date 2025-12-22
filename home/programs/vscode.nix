{ lib, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions =
        (with pkgs.vscode-extensions; [
          # Theme
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
          # Nix
          jnoortheen.nix-ide
          # Markdown
          yzhang.markdown-all-in-one
          davidanson.vscode-markdownlint
          bierner.markdown-preview-github-styles
          rust-lang.rust-analyzer
          ziglang.vscode-zig
          golang.go
          ms-python.python
          # C/C++
          llvm-vs-code-extensions.vscode-clangd
          ms-vscode.cpptools
          hashicorp.terraform
          redhat.vscode-yaml
          ms-azuretools.vscode-docker
          # Typst
          myriad-dreamin.tinymist
          ms-kubernetes-tools.vscode-kubernetes-tools
          bazelbuild.vscode-bazel
        ])
        ++ (with pkgs.vscode-marketplace; [
          anthropic.claude-code
          # Jujutsu
          jjk.jjk
        ]);
      userSettings = {
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
      };
    };
  };
}
