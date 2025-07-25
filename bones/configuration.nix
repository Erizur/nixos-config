{ config, lib, pkgs, ... }:
{
  # Enable tailscale
  services.tailscale.enable = true;

  # Flake support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc.options = "--delete-older-than 7d";
  
  # Packages
  environment.systemPackages = with pkgs; [
    git neovim wget tree

    p7zip unzip unrar
    
    cmake ninja
    clang clang-tools lldb
    direnv

    fortune cowsay

    jdk17 jdk8
    uutils-coreutils-noprefix
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    wineWowPackages.staging
    winetricks

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
    
    keyd libpulseaudio lact xdg-utils alsa-utils 
    (pkgs.callPackage ../extrapkgs/kshift.nix {}) 
  ];

  environment.variables.EDITOR = "nvim";

  programs.zsh.enable = true;

  fonts = {
  	packages = with pkgs; [
	    noto-fonts noto-fonts-cjk-sans noto-fonts-emoji liberation_ttf
	    aileron fragment-mono comic-mono work-sans hubot-sans eurofurence
	    dosis manrope montserrat helvetica-neue-lt-std mplus-outline-fonts.githubRelease
      fira-code fira-code-symbols
	    nerd-fonts.fira-code
	    nerd-fonts.ubuntu
	    nerd-fonts.hack
	    nerd-fonts.comic-shanns-mono
      nerd-fonts.jetbrains-mono
	
	    carlito dejavu_fonts ipafont kochi-substitute source-code-pro
	    ttf_bitstream_vera
  	];
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      nix-vscode-extensions.overlays.default
    ];
  };
}
