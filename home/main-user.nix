{ config, pkgs, system, inputs, extraGaming, ... }:
let 
  duckstation-src = import inputs.duckstation-unofficial {system = "${system}"; config.allowUnfree = true;};
in
{
  home.username = "erizur";
  home.homeDirectory = "/home/erizur";
  home.stateVersion = "25.05";
  
  imports = [
    ./modules
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = with pkgs; [
    lutris
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
    duckstation-src.duckstation
    
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
          size = 48;
          package = 
            pkgs.runCommand "moveUp" {} ''
              mkdir -p $out/share/icons
              ln -s ${self}/cursor $out/share/icons/Oxygen-Zion
          '';
        };
  programs.home-manager.enable = true;
}

