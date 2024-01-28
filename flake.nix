{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager";

    nur.url = github:nix-community/NUR;

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
              pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
                overlays = [ ];
              };
            in
            { inherit pkgs system; }
          )
        ));


      mkSystem = system: username: fn: fn
        (rec {
          inherit username system;

          lib = nixpkgs.lib.extend (final: prev: { } // home-manager.lib);

          modules = import ./modules { inherit lib; };
        });
    in
    {

      nixosConfigurations.evgeniya = mkSystem "x86_64-linux" "pml"
        ({ lib, modules, system, username }: nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs lib system username; };
          modules = lib.flatten [
            modules
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

      darwinConfigurations."magda" =
        let
          username = "pmlogist";
        in
        darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs system username;
            lib = nixpkgs.lib.extend (self: super: { } // home-manager.lib);
          };
          modules =
            import ./modules { lib = nixpkgs.lib; }
            ++ [
              home-manager.darwinModules.home-manager
              # { environment.systemPackages = [ inputs.agenix.packages.${system}.default ]; }
              (import ./machines/magda)
              (import ./users/pml)
            ];
        };

      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixpkgs-fmt);

      devShells = forAllSystems ({ pkgs, ... }: {
        default = pkgs.mkShell {
          packages = [ ];
        };

      });
    };
}
