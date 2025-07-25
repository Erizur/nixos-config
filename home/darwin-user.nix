{ config, pkgs, system, inputs, ... }: 
{
  home.stateVersion = "25.05";
  
  imports = [
    ./modules/nvim/default.nix
    ./modules/zsh.nix
    ./modules/vscode.nix
    ./modules/git.nix
    ./modules/mpv.nix
  ];

  home.packages = with pkgs; [
    lolcat fortune
    figlet cmatrix
    (jetbrains.clion.override {
      jdk = pkgs.openjdk21;
    })
	
    qbittorrent
    chromium
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
