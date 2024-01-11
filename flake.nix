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
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs @ {
    self,
    darwin,
    home-manager,
    nixpkgs,
    nur,
    ...
  }: {
    nixosConfigurations."evgeniya" = let
      username = "pml";
    in
      nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs system username;
          mod = name: "./modules/${name}";
          lib = nixpkgs.lib.extend (self: super: {} // home-manager.lib);
        };
        modules =
          import ./modules {lib = nixpkgs.lib;}
          ++ [
            home-manager.nixosModules.home-manager
            nur.nixosModules.nur
            (import ./machines/evgeniya)
            (import ./users/pml)
            inputs.sops-nix.nixosModules.sops
            inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
            {
              home-manager.useGlobalPkgs = true;
              home-manager.extraSpecialArgs = {
                inherit username;
                # lib = nixpkgs.lib.extend (self: super: { } // home-manager.lib);
              };
            }
          ];
      };

    nixosConfigurations."nixos-vm" = let
      username = "pml";
    in
      nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";
        specialArgs = {inherit inputs system username;};
        modules = [
          home-manager.nixosModules.home-manager
          (import ./machines/vm)
          (import ./users/pml/vm.nix)
        ];
      };

    darwinConfigurations."magda" = let
      username = "pmlogist";
    in
      darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs system username;
          lib = nixpkgs.lib.extend (self: super: {} // home-manager.lib);
        };
        modules =
          import ./modules {lib = nixpkgs.lib;}
          ++ [
            home-manager.darwinModules.home-manager
            # { environment.systemPackages = [ inputs.agenix.packages.${system}.default ]; }
            (import ./machines/magda)
            (import ./users/pml)
          ];
      };
  };
}
