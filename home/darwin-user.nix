{ config, pkgs, system, inputs, ... }: 
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

    pcsx2-bin
    duckstation-bin
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
