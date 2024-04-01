{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    darwinpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";

    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "darwinpkgs";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager/release-23.11";

    nur.url = "github:nix-community/NUR";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs @ { self, darwin, home-manager, nixpkgs, nur, ... }:
    let
      systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      forAllSystems = function:
        (nixpkgs.lib.genAttrs systems (
          system:
          function (
            let
              pkgs = nixpkgs.legacyPackages.${system};
            in
            { inherit pkgs system; }
          )
        ));


      mkSystem = system: username: fn: fn
        (rec {
          inherit username system;

          lib = nixpkgs.lib.extend
            (final: prev: { }
              // (import ./lib { lib = nixpkgs.lib; })
              // home-manager.lib
            );

          modules = lib.recursiveImports ./modules;
        });

    in
    {
      nixosConfigurations.evgeniya = mkSystem "x86_64-linux" "pml"
        ({ lib, modules, system, username }: nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs lib system username; };
          modules = lib.flatten [
            modules
            (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" username ])
            (import ./machines/evgeniya)
          ];
        });

      nixosConfigurations."nixos-vm" = let username = "pml"; in
        nixpkgs.lib.nixosSystem rec {
          system = "aarch64-linux";
          specialArgs = { inherit inputs system username; };
          modules = [
            home-manager.nixosModules.home-manager
            (import ./machines/vm)
            (import ./users/pml/vm.nix)
          ];
        };

      darwinConfigurations.magda = mkSystem "aarch64-darwin" "pml"
        ({ lib, modules, system, username, ... }: darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs lib system username; };
          modules = lib.flatten [
            modules
            (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" username ])
            (import ./machines/magda)
          ];

        });

      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixpkgs-fmt);

      devShells = forAllSystems ({ pkgs, ... }: {
        default = pkgs.mkShell {
          packages = [ ];
        };

      });
    };
}
