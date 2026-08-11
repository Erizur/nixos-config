{ self, config, pkgs, system, inputs, extraGaming, ... }:
let  
  cursor-path = ../cursor;
in
{
  home.username = "erizur";
  home.homeDirectory = "/home/erizur";
  home.stateVersion = "25.11";
  home.sessionPath = [ "$HOME/.local/bin" ];
  
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
    xournalpp
    cider-2

    supertuxkart
    supertux
    pingus
    pcsx2
    prismlauncher
    # temporary fix for duckstation since the packaging broke in upstream nixpkgs
    # they will take 1562 business days to fix it so i had to do manual revert
    # update: they will not. thank mr keznets' upstream for that!
    (pkgs.callPackage ../extrapkgs/duckstation/package.nix { })
    
    any-nix-shell
  ] ++ lib.optionals (extraGaming == true) [
    teeworlds hedgewars
    ares
    rmg-wayland
    dolphin-emu
    mame scummvm
  ];

  xresources.properties = {
    "Xcursor.size" = 24;
    "Xcursor.theme" = "Oxygen-Zion";
    "Xft.antialias" = 1;
    "Xft.hinting" = 1;
    "Xft.hintstyle" = "hintslight";
    "Xft.rgba" = "none";
  };

  home.pointerCursor = {
          enable = true;
          gtk.enable = true;
          x11.enable = true;
          name = "Oxygen-Zion";
          size = 24;
          package = (pkgs.callPackage ../cursor/package.nix {}); 
        };
  programs.home-manager.enable = true;
}

