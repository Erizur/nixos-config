{
  description = "Nice computer you got there, can I have it?";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    marble-browser = {
      url = "github:Erizur/marble-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:Erizur/nix-vscode-extensions/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, quickshell, nix-vscode-extensions, sops-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        # i got a new one
        makoto = nixpkgs.lib.nixosSystem {
          specialArgs = { extraGaming = true; inherit inputs; inherit system; };
          modules = [
            ./bones/configuration.nix
            ./bones/nixos/configuration.nix
            ./bones/nixos/makoto/configuration.nix
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
                  ./home/modules/fluidsynth.nix
                  ./home/modules/branding/makoto.nix
                ];
                sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
              };
            }
          ];
        };

        # uni laptop
        sajou = nixpkgs.lib.nixosSystem {
          specialArgs = { extraGaming = false; inherit inputs; inherit system; };
          modules = [
            ./bones/configuration.nix
            ./bones/nixos/configuration.nix
            ./bones/nixos/sajou/configuration.nix
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
