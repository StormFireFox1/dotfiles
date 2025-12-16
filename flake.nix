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
    hyprshell = {
      url = "github:H3rmt/hyprshell/hyprshell-release";
      inputs.hyprland.follows = "hyprland";
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
      ...
    }@inputs:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      lib = pkgs.lib;
    in
    {
      homeConfigurations = {
        ghost = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            agenix.homeManagerModules.default
            inputs.catppuccin.homeModules.catppuccin
            inputs.nix-doom-emacs-unstraightened.homeModule
            inputs.charmbracelet-nur.homeModules.crush
	    inputs.hyprshell.homeModules.hyprshell
            { nixpkgs.overlays = [ inputs.claude-code-nix.overlays.default ]; }
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
            nixfmt-tree
            agenix.packages.${system}.default
          ];
        };
      }
    );
}
