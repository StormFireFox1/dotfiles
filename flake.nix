{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
    }@inputs:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {
      homeConfigurations = {
        ghost = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home/main.nix
            ./home/starship.nix
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
