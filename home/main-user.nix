{ config, pkgs, system, inputs, extraGaming, ... }:
let 
  duckstation-src = import inputs.duckstation-unofficial {system = "${system}"; config.allowUnfree = true;};
  fooyin = import inputs.fooyin {system = "${system}"; config.allowUnfree = true;};
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
    lolcat
    figlet fortune cmatrix hollywood jp2a
    (jetbrains.clion.override {
      jdk = pkgs.openjdk21;
    })
    lutris bottles
	
    inputs.marble-browser.packages."${system}".default.override
    qbittorrent
    chromium
    vesktop
    zoom-us
    
    obsidian
    onlyoffice-desktopeditors

    vlc
    cider-2
    (
      fooyin.fooyin.override {
        src = pkgs.fetchFromGitHub {
          owner = "ludouzi";
          repo = "fooyin";
          tag = "v" + finalAttrs.version;
          hash = "sha256-pkzBuJkZs76m7I/9FPt5GxGa8v2CDNR8QAHaIAuKN4w=";
        };
      }
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

