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
    (duckstation.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "stenzek";
        repo = "duckstation";
        tag = "v0.1-10413";
        deepClone = true;
        hash = "sha256-ksmxdYLFWYIA3Kp8dztyN4UxeJFvpNRmN79TspwZHuw=";
      };
    }))
    
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

