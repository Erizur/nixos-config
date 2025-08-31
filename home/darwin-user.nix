{ config, pkgs, system, inputs, ... }: 
let 
  duckstation-src = import inputs.duckstation-unofficial {system = "${system}"; config.allowUnfree = true;};
in
{
  home.username = "erizur";
  home.stateVersion = "25.05";
  
  imports = [
    ./modules
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = with pkgs; [
    lolcat fortune
    figlet cmatrix
    (jetbrains.clion.override {
      jdk = pkgs.openjdk21;
    })
	
    qbittorrent
    vesktop
    zoom-us
    obsidian

    nil # Soporte para nix
    alejandra
    pyright

    wl-clipboard
    cmake-language-server

    duckstation-src.duckstation-unofficial
    pcsx2-bin
    dolphin-emu
    ares
    prismlauncher
    scummvm
    mame

    zip xz
    bat ripgrep fd
    
    mame-tools
    any-nix-shell
  ];

  programs.home-manager.enable = true;
}
