{ config, pkgs, system, inputs, extraGaming, ... }:
let 
  duckstation-src = import inputs.duckstation-unofficial {system = "${system}"; config.allowUnfree = true;};
  fooyin-src = import inputs.fooyin {system = "${system}"; config.allowUnfree = true;};
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
    lolcat figlet fortune cmatrix hollywood jp2a
    jetbrains.clion
    lutris
    (bottles.override {
      extraLibraries = pkgs: [
        pkgs.fluidsynth
      ];
    })
	
    inputs.marble-browser.packages."${system}".default
    qbittorrent
    chromium
    vesktop
    zoom-us
    
    obsidian
    onlyoffice-desktopeditors

    vlc
    cider-2
    (
      fooyin-src.fooyin.overrideAttrs (oldAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "ludouzi";
          repo = "fooyin";
          tag = "v0.9.1";
          hash = "sha256-549AtdldAPFengQsVXMnZI0mVzUwgKgUKAfR0Ro3s2I=";
        };
      })
    )
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
    duckstation-src.duckstation-unofficial
    
    mame-tools
    any-nix-shell
  ] ++ lib.optionals (extraGaming == true) [
    teeworlds hedgewars
    ares
    rmg-wayland
    dolphin-emu
    mame scummvm
  ];

  home.file.".icons/default".source = "${pkgs.kdePackages.breeze}/share/icons/breeze_cursors";
  programs.home-manager.enable = true;
}

