{config, lib, pkgs, inputs, system, ... }:
{
  # Enable tailscale
  services.tailscale.enable = if pkgs.stdenv.isLinux then true else false;

  # Flake support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc.options = "--delete-older-than 7d";
  nix.settings.trusted-users = ["root" "erizur"];
  
  # Packages
  environment.systemPackages = with pkgs; [
    git neovim wget tree
    lolcat figlet fortune cmatrix 

    p7zip unzip unrar
    zip xz bat ripgrep fd
    
    cmake ninja
    direnv

    fortune cowsay
    sops age

    jdk21 jdk17
    imagemagickBig
    mame-tools

    nil alejandra
    pyright 
    cmake-language-server
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    hollywood jp2a
    uutils-coreutils-noprefix
    clang clang-tools lldb wl-clipboard

    wineWowPackages.stagingFull
    winetricks wineasio

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi

    kdePackages.kcalc
    kdePackages.kolourpaint
    kdePackages.oxygen-sounds
    krita gimp3
    aseprite
    
    qbittorrent
    memento vlc
    tenacity
    fooyin
    
    cage
    (inputs.quickshell.packages."${system}".default.withModules [kdePackages.qt5compat kdePackages.qtmultimedia])
    
    keyd libpulseaudio xdg-utils alsa-utils 
    (pkgs.callPackage ../extrapkgs/kshift.nix {})
    (pkgs.callPackage ../extrapkgs/soulseekqt.nix {})
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    
  ];

  environment.variables = {
    EDITOR = "nvim";
  } // lib.optionals pkgs.stdenv.isLinux {
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "fcitx";
    GTK_IM_MODULE = "wayland";
    QT_IM_MODULES = "wayland;fcitx;ibus";
    SDL_IM_MODULE = "fcitx";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    NIXOS_OZONE_WL = "1";
    GST_PLUGIN_PATH = "/run/current-system/sw/lib/gstreamer-1.0/";
    GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
      pkgs.gst_all_1.gstreamer.out	
	  pkgs.gst_all_1.gst-plugins-base
	  pkgs.pkgsi686Linux.gst_all_1.gst-plugins-base
	  pkgs.gst_all_1.gst-plugins-good
	  pkgs.pkgsi686Linux.gst_all_1.gst-plugins-good
	  pkgs.gst_all_1.gst-plugins-bad
	  pkgs.pkgsi686Linux.gst_all_1.gst-plugins-bad
	  pkgs.gst_all_1.gst-plugins-ugly
	  pkgs.pkgsi686Linux.gst_all_1.gst-plugins-ugly
      pkgs.gst_all_1.gst-libav
	  pkgs.pkgsi686Linux.gst_all_1.gst-libav
	  pkgs.gst_all_1.gst-vaapi
	  pkgs.pkgsi686Linux.gst_all_1.gst-vaapi ];
  };

  programs.zsh.enable = true;

  fonts = {
  	packages = with pkgs; [
	  noto-fonts noto-fonts-cjk-sans noto-fonts-emoji liberation_ttf oxygenfonts
	  junction-font aileron fragment-mono comic-mono comic-neue comic-relief work-sans hubot-sans eurofurence
	  dosis manrope montserrat helvetica-neue-lt-std mplus-outline-fonts.githubRelease
    fira-code fira-code-symbols
	  nerd-fonts.fira-code
	  nerd-fonts.ubuntu
	  nerd-fonts.hack
	  nerd-fonts.comic-shanns-mono
    nerd-fonts.jetbrains-mono
	
	  carlito dejavu_fonts ipafont source-code-pro
	  ttf_bitstream_vera
  	] ++ lib.optionals pkgs.stdenv.isLinux [ kochi-substitute ];
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs.nix-vscode-extensions.overlays.default
    ];
  };
}
