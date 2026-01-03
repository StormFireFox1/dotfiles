{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    charmbracelet-nur = {
      url = "github:charmbracelet/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code-nix = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprshell = {
      url = "github:H3rmt/hyprshell/hyprshell-release";
      inputs.hyprland.follows = "hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      agenix,
      home-manager,
      darwin,
      nix-homebrew,
      treefmt-nix,
      ...
    }@inputs:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      darwin_pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
      lib = pkgs.lib;
      commonHomeModules = [
        agenix.homeManagerModules.default
        inputs.catppuccin.homeModules.catppuccin
        inputs.nix-doom-emacs-unstraightened.homeModule
        inputs.charmbracelet-nur.homeModules.crush
        inputs.hyprshell.homeModules.hyprshell
        {
          nixpkgs.overlays = [
            inputs.claude-code-nix.overlays.default
            inputs.nix-vscode-extensions.overlays.default
          ];
        }
        ./modules/home
      ];
    in
    {
      homeConfigurations = {
        "ghost@BullshitMachine" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = commonHomeModules ++ [
            {
              fireflake = {
                username = "ghost";
                backup.enable = true;
                hypr.enable = true;
                programs = {
                  enable = true;
                  wayland.enable = true;
                };
              };
            }
          ];
        };
        "ghost@StormPrism" = home-manager.lib.homeManagerConfiguration {
          pkgs = darwin_pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = commonHomeModules ++ [
            {
              fireflake = {
                username = "ghost";
                backup = {
                  enable = true;
                  repoName = "StormPrism";
                };
                programs = {
                  enable = true;
                };
              };
            }
          ];
        };
      };

      nixosConfigurations.BullshitMachine = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          meta = {
            hostname = "BullshitMachine";
          };
        };
        system = "x86_64-linux";
        modules = [
          agenix.nixosModules.default
          ./lib/agenix.nix
          ./BullshitMachine/hardware-configuration.nix
          ./BullshitMachine/nvidia.nix
          ./BullshitMachine/configuration.nix
        ];
      };

      darwinConfigurations.StormPrism = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          ./modules/darwin
          ./modules/darwin/hosts/StormPrism.nix
        ];
        specialArgs = { inherit inputs; };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        treefmt = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        formatter = treefmt.config.build.wrapper;
        checks = {
          formatting = treefmt.config.build.check self;
        };
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nixfmt-tree
            nixfmt-rfc-style
            agenix.packages.${system}.default
            nh
            home-manager.packages.${system}.default
          ];
        };
      }
    );
}
