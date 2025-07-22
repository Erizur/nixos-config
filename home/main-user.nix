{ pkgs, ... }: 
{
  home.username = "Erizur";
  home.homeDirectory = "/home/erizur";
  home.stateVersion = "25.05";
  
  imports = [
    ./modules/nvim/default.nix
    ./modules/zsh.nix
    ./modules/vscode.nix
  ];

  home.packages = with pkgs; [
    lolcat
    figlet fortune cmatrix hollywood jp2a
    jetbrains.clion
    lutris bottles
	
    (
      inputs.marble-browser.packages."${system}".default.override {
        nativeMessagingHosts = [pkgs.firefoxpwa pkgs.kdePackages.plasma-browser-integration];
      }
    )
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
    scummvm
    mame

    zip xz

    bat gh ripgrep fd
    
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

  home.file.".icons/default".source = "${pkgs.kdePackages.breeze}/share/icons/breeze_cursors";
  
  programs.home-manager.enable = true;
}

