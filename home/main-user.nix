{ pkgs, ... }: {
  home.username = "Erizur";
  home.homeDirectory = "/home/erizur";
  home.stateVersion = "24.11";
  
  imports = [
    ./modules/fastfetch/default.nix
    ./modules/nvim/default.nix
    ./modules/zsh/default.nix
    ./modules/vscode/default.nix
  ];

  home.packages = with pkgs; [
    lolcat cowsay
    figlet fortune cmatrix hollywood jp2a
    jetbrains.clion
    wine winetricks lutris bottles
    obsidian
	
    inputs.marble-browser.packages."${system}".default
    chromium
    vesktop
    zoom-us

    vlc
    fooyin
    soulseekqt

    kdePackages.kcalc
    kdePackages.kolourpaint
    krita

    nil # Soporte para nix
    alejandra
    pyright

    wl-clipboard
    cmake-language-server
    keepassxc
    ardour

    superTuxKart
    superTux
    hedgewars
    teeworlds
    pingus
    pcsx2
    duckstation
    prismlauncher

    zip
    xz

    bat
    gh
    ripgrep
    fd
    
    mame-tools
    any-nix-shell
  ];

  programs.git = {
    enable = true;
    userName = "AM_Erizur";
    userEmail = "sjdks@outlook.com";
    
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  
  programs.home-manager.enable = true;
 }

