{ config, lib, pkgs, ... }:
let
  inherit (pkgs) stdenv;
  inherit (lib) mkIf;
in
{
  # Enable tailscale
  services.tailscale.enable = true;

  # Flake support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Packages
  environment.systemPackages = with pkgs; [
    git neovim wget tree

    p7zip unzip unrar

    (mkIf stdenv.isLinux (pkgs.callPackage ../extrapkgs/kshift.nix {}))
    
    cmake ninja
    clang clang-tools lldb
    direnv
    
    wineWowPackages.staging
    winetricks

    keyd fortune cowsay

    libpulseaudio
    lact

    xdg-utils
    alsa-utils

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi

    jdk17 jdk8
    uutils-coreutils-noprefix
  ];

  environment.variables.EDITOR = "nvim";

  programs.steam = {
  	enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  services.displayManager.sddm = {
  	enable = true;
  	wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;
  programs.dconf.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  fonts = {
  	packages = with pkgs; [
	    noto-fonts noto-fonts-cjk-sans noto-fonts-emoji liberation_ttf
	    aileron fragment-mono comic-mono work-sans hubot-sans eurofurence
	    dosis manrope montserrat helvetica-neue-lt-std
	    nerd-fonts.fira-code
	    nerd-fonts.ubuntu
	    nerd-fonts.hack
	    nerd-fonts.comic-shanns-mono
	
	    carlito dejavu_fonts ipafont kochi-substitute source-code-pro
	    ttf_bitstream_vera
  	];

  	fontconfig = {
      useEmbeddedBitmaps = true;
      defaultFonts = {
          monospace = [
            "JetBrainsMono Nerd Font"
            "IPAGothic"
          ];
          sansSerif = [
            "Noto Sans"
            "IPAGothic"
          ];
          serif = [
            "Noto Serif"
            "IPAPMincho"
          ];
      };
    };
  };

  # Locale settings.
  i18n = {
    defaultLocale = "ja_JP.UTF-8";
      inputMethod = {
      enable = true;
        type = "fcitx5";
        fcitx5.addons = with pkgs; [
            fcitx5-mozc
            kdePackages.fcitx5-qt
        ];
    };
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          alt = {
            "`" = "hiragana";
            capslock = "muhenkan";
            home = "katakanahiragana";
          };
        };
      };
    };
  };
  
  nix.gc.options = "--delete-older-than 7d";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05"; # Don't change this unless fully reinstalling
}
