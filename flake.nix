{
  description = "Nice computer you got there, can I have it?";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    marble-browser = {
      url = "github:Erizur/marble-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        # current desktop (will redo when i get a new one)
        ts140 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./bones/configuration.nix
            ./bones/nixos/ts140/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.erizur.imports = [
                  ./home/main-user.nix
                  ./home/modules/fastfetch/makoto.nix
                ];
              };
            }
          ];
        };

        # uni laptop
        sjdks = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./bones/configuration.nix
            ./bones/nixos/sjdks/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.erizur.imports = [
                  ./home/main-user.nix
                  ./home/modules/fastfetch/pitcher56.nix
                ];
              };
            }
          ];
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        name = "nix-devenv";
        buildInputs = with pkgs; [
          nil
          alejandra
          git
          nix-index

          fortune
          cowsay
        ];

        shellHook = ''
          export NIX_LSP_FORMATTER=alejandra
        '';
      };
    };
}
