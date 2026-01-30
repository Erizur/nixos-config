{ self, config, pkgs, system, inputs, extraGaming, ... }:
let  
  cursor-path = ../cursor;
in
{
  home.username = "erizur";
  home.homeDirectory = "/home/erizur";
  home.stateVersion = "25.11";
  
  imports = [
    ./modules
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = with pkgs; [
    (bottles.override {
      extraLibraries = pkgs: [
        pkgs.fluidsynth
      ];
    })
	
    inputs.marble-browser.packages."${system}".default
    chromium
    vesktop
    zoom-us
    
    obsidian
    onlyoffice-desktopeditors
    cider-2
    
    obs-studio

    superTuxKart
    superTux
    pingus
    pcsx2
    prismlauncher
    # temporary fix for duckstation since the packaging broke in upstream nixpkgs
    # they will take 1562 business days to fix it so i had to do manual revert
    (pkgs.callPackage ../extrapkgs/duckstation/package.nix { })
    
    any-nix-shell
  ] ++ lib.optionals (extraGaming == true) [
    teeworlds hedgewars
    ares
    rmg-wayland
    dolphin-emu
    mame scummvm
  ];

  home.pointerCursor = {
          gtk.enable = true;
          x11.enable = true;
          name = "Oxygen-Zion";
          size = 24;
          package = (pkgs.callPackage ../cursor/package.nix {}); 
        };
  programs.home-manager.enable = true;
}

