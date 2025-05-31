# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ 
      ./hardware-configuration.nix
    ];

  # Use the GRand Unified Bootloader
  boot.loader = {
    efi = {
		canTouchEfiVariables = true;
		efiSysMountPoint = "/boot";
    };
	grub = {
		enable = true;
		efiSupport = true;
		device = "nodev";
		useOSProber = true;
	};
  };

  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=0" ];

  networking = {
  	hostName = "ts140"; # Define your hostname.
  	networkmanager.enable = true;  # Easiest to use and most distros use this by default.
	firewall.enable = true;
	firewall.trustedInterfaces = [ "tailscale0" ];
  	nameservers = [
    	"1.1.1.1"
    	"1.0.0.1"
    	"8.8.8.8"
    	"8.8.4.4"
  	];
  };

  # Time zone & dualboot shenanigans.
  time = {
  	timeZone = "America/Lima";
  	hardwareClockInLocalTime = true;
  };

  # Locale settings.
  i18n.defaultLocale = "ja_JP.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver = {
  	enable = true;
	xkb.layout = "es";
  };

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
	audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
	wireplumber.enable = true;
  };

  # Enable tailscale
  services.tailscale.enable = true;

  # Define the current user.
  users.users.erizur = {
    isNormalUser = true;
	shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "bluetooth"]; # Enable ‘sudo’ for the user.
    home = "/home/erizur";
  };

  # List packages installed in system profile. To search, run:
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Packages
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
	tree

	p7zip
	unzip
	unrar

    (pkgs.callPackage ./extra/kshift.nix {})
    
    cmake
    ninja
    clang
    clang-tools
    lldb
    direnv
    
    wineWowPackages.staging
    winetricks

    keyd
    fortune

	jdk17
	jdk8
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

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  fonts = {
  	packages = with pkgs; [
    	noto-fonts
    	noto-fonts-cjk-sans
    	noto-fonts-emoji
    	liberation_ttf
    	fira-code
    	fira-code-symbols
    	mplus-outline-fonts.githubRelease
    	dina-font
    	proggyfonts
    	nerd-fonts.jetbrains-mono
    	ttf_bitstream_vera
    	ipafont
    	kochi-substitute
    	carlito
    	hubot-sans
    	eurofurence
    	comic-mono
    	montserrat
    	helvetica-neue-lt-std
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
  };
  
  nix.gc.options = "--delete-older-than 7d";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11" # Don't change this unless fully reinstalling
}

