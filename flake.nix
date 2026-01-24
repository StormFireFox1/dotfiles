{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      # NOTE: Pinning to before hyprpm was enabled
      # until https://github.com/hyprwm/Hyprland/pull/13048 lands.
      url = "github:hyprwm/Hyprland/8f547c6fa089f91e7577947c426f692397e9a5cb";
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
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    charm-nur = {
      url = "github:charmbracelet/nur";
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
        inputs.hyprshell.homeModules.hyprshell
        inputs.charm-nur.homeModules.crush
        {
          nixpkgs.overlays = [
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
            agenix.packages.${system}.default
            nh
            home-manager.packages.${system}.default
          ];
        };
      }
    );
}
