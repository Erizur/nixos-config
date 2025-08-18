{ config, pkgs, system, inputs, extraGaming, ... }:
{
  home.username = "erizur";
  home.homeDirectory = "/home/erizur";
  home.stateVersion = "25.05";
  
  imports = [
    ./modules
    inputs.sops-nix.homeManagerModules.sops
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
    onlyoffice-desktopeditors

    vlc
    fooyin
    memento
    tenacity
    obs-studio

    kdePackages.kcalc
    kdePackages.kolourpaint
    krita
    gimp3
    aseprite

    nil # Soporte para nix
    alejandra
    pyright

    wl-clipboard
    cmake-language-server

    superTuxKart
    superTux
    pingus
    pcsx2
    prismlauncher
    
    mame-tools
    any-nix-shell
  ] ++ lib.optionals (extraGaming == true) [
    teeworlds hedgewars
    duckstation
    ares
    rmg-wayland
    dolphin-emu
    mame scummvm
  ];

  home.file.".icons/default".source = "${pkgs.kdePackages.breeze}/share/icons/breeze_cursors";
  programs.home-manager.enable = true;
}

