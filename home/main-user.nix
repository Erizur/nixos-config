{ config, pkgs, system, inputs, ... }: 
{
  home.username = "erizur";
  home.homeDirectory = "/home/erizur";
  home.stateVersion = "25.05";
  
  imports = [
    ./modules/nvim/default.nix
    ./modules/zsh.nix
    ./modules/vscode.nix
    ./modules/git.nix
    ./modules/mpv.nix
  ];

  home.packages = with pkgs; [
    lolcat
    figlet fortune cmatrix hollywood jp2a
    (jetbrains.clion.override {
      jdk = pkgs.openjdk21;
    })
    lutris bottles
	
    (
      inputs.marble-browser.packages."${system}".default.override {
        nativeMessagingHosts = [pkgs.firefoxpwa pkgs.kdePackages.plasma-browser-integration];
      }
    )
    qbittorrent
    chromium
    vesktop
    zoom-us
    obsidian

    vlc
    fooyin
    memento
    tenacity
    obs-studio

    kdePackages.kcalc
    kdePackages.kolourpaint
    krita
    gimp3

    nil # Soporte para nix
    alejandra
    pyright

    wl-clipboard
    cmake-language-server
    ardour

    superTuxKart
    superTux
    hedgewars
    teeworlds
    pingus
    pcsx2
    duckstation
    prismlauncher
    scummvm
    mame

    zip xz
    bat gh ripgrep fd
    
    mame-tools
    any-nix-shell
  ];

  home.file.".icons/default".source = "${pkgs.kdePackages.breeze}/share/icons/breeze_cursors";
  programs.home-manager.enable = true;
}

