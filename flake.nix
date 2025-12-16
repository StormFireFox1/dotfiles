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
  };

  outputs =
    {
      self,
      nixpkgs,
      catppuccin,
      flake-utils,
      agenix,
      home-manager,
      nix-doom-emacs-unstraightened,
    }@inputs:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      lib = pkgs.lib;
    in
    {
      homeConfigurations = {
        ghost = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            agenix.homeManagerModules.default
            catppuccin.homeModules.catppuccin
	    nix-doom-emacs-unstraightened.homeModule
          ]
          ++ lib.filter (x: lib.strings.hasSuffix ".nix" x) (lib.filesystem.listFilesRecursive ./home);
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
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nixfmt-rfc-style
            agenix.packages.${system}.default
          ];
        };
      }
    );
}
