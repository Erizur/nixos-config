{ config, pkgs, system, inputs, ... }: 
{
  home.stateVersion = "25.05";
  
  imports = [
    ./modules/nvim/default.nix
    ./modules/zsh.nix
    ./modules/vscode.nix
    ./modules/git.nix
    ./modules/mpv.nix
    inputs.marble-browser.homeModules.marble
  ];

  home.packages = with pkgs; [
    lolcat fortune
    figlet cmatrix hollywood jp2a
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

    superTuxKart
    pcsx2-bin
    duckstation-bin
    prismlauncher
    scummvm
    mame

    zip xz
    bat gh ripgrep fd
    
    mame-tools
    any-nix-shell
  ];

  # Enable Marble for macOS
  programs.marble-browser.enable = true;

  programs.home-manager.enable = true;
}
