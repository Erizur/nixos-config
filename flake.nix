{
  description = "Nice computer you got there, can I have it?";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    marble-browser = {
      url = "github:Erizur/marble-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    duckstation-unofficial.url = "github:normalcea/nixpkgs/init-duckstation-unofficial";
    fooyin.url = "github:keenanweaver/nixpkgs/fooyin-0.9.0";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Homebrew package manager support
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, fooyin, duckstation-unofficial, home-manager, nix-vscode-extensions, nix-darwin, sops-nix, ... }@inputs: 
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
            ./bones/nixos/configuration.nix
            ./bones/nixos/ts140/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            {
              home-manager = {
                extraSpecialArgs = { extraGaming = true; inherit inputs; inherit system; };
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.erizur.imports = [
                  ./home/main-user.nix
                  ./home/modules/branding/makoto.nix
                ];
                sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
              };
            }
          ];
        };

        # uni laptop
        sjdks = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./bones/configuration.nix
            ./bones/nixos/configuration.nix
            ./bones/nixos/sjdks/configuration.nix
            inputs.nixos-hardware.nixosModules.lenovo-ideapad-15ach6
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            {
              home-manager = {
                extraSpecialArgs = { extraGaming = false; inherit inputs; inherit system; };
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.erizur.imports = [
                  ./home/main-user.nix
                  ./home/modules/branding/pitcher56.nix
                ];
                sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        ts140 = nix-darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./bones/configuration.nix
            ./bones/darwin/configuration.nix
            inputs.home-manager.darwinModules.home-manager
            inputs.sops-nix.darwinModules.sops
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; inherit system; };
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.erizur.imports = [
                  ./home/darwin-user.nix
                  ./home/modules/branding/makoto.nix
                ];
                sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
              };
            }
            inputs.nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                user = "erizur";
                taps = {
                  "homebrew/homebrew-core" = inputs.homebrew-core;
                  "homebrew/homebrew-cask" = inputs.homebrew-cask;
                  "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                };
                mutableTaps = false;
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
