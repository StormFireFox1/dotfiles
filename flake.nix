{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    catppuccin.url = "github:catppuccin/nix";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Personal fork of Attic until Nix 2.31 support is merged in.
    attic = {
      url = "github:StormFireFox1/attic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
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
    noctalia = {
      url = "github:noctalia-dev/noctalia";
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
    paseo = {
      url = "github:getpaseo/paseo";
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
      paseo,
      attic,
      ...
    }@inputs:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      darwinPkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
      lib = pkgs.lib;
      commonHomeModules = [
        agenix.homeManagerModules.default
        inputs.catppuccin.homeModules.catppuccin
        inputs.nix-doom-emacs-unstraightened.homeModule
        inputs.charm-nur.homeModules.crush
        inputs.noctalia.homeModules.default
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
                hypr = {
                  enable = true;
                  shellType = "noctalia";
                };
                programs = {
                  enable = true;
                  wayland.enable = true;
                };
              };
            }
          ];
        };
        "ghost@StormPrism" = home-manager.lib.homeManagerConfiguration {
          pkgs = darwinPkgs;
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
          paseo.nixosModules.default
          ./modules/nixos/base
          ./modules/nixos/bullshit-machine
          {
            fireflake.nixos = {
              type = "desktop";
              desktop.dedicatedGraphicsType = "nvidia";
              desktop.wakeOnLanInterface = "eno2";
            };
          }
        ];
      };

      nixosConfigurations.RescueUSB = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          meta = {
            hostname = "rescue";
          };
        };
        system = "x86_64-linux";
        modules = [
          agenix.nixosModules.default
          ./modules/nixos/base
          ./modules/nixos/rescue-usb
          home-manager.nixosModules.home-manager
          {
            fireflake.nixos.type = "server";
            fireflake.nixos.nix.pullAtticCaches = false;

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.ghost =
                { ... }:
                {
                  imports = commonHomeModules;
                  fireflake = {
                    username = "ghost";
                    backup.enable = false;
                    hypr.enable = false;
                    programs.enable = true;
                    programs.wayland.enable = false;
                    programs.dev.enable = false;
                  };
                };
            };
          }
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
            git
            agenix.packages.${system}.default
            nh
            home-manager.packages.${system}.default
          ];
        };
        packages = pkgs.lib.optionalAttrs (system == "x86_64-linux") {
          rescue-iso = self.nixosConfigurations.RescueUSB.config.system.build.isoImage;
        };
      }
    );
}
