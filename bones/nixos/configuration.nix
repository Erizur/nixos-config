{ config, lib, pkgs, ... }:
{
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

  networking = {
  	networkmanager = {
      enable = true;  # Easiest to use and most distros use this by default.
      plugins = with pkgs; [ networkmanager-openvpn ];
    };
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
  };

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
  services.avahi.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;

    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
      };
    };
    extraConfig.pipewire-pulse."92-low-latency" = {
      context.modules = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            pulse.min.req = "1024/48000";
            pulse.default.req = "1024/48000";
            pulse.min.frag = "256/48000";
            pulse.min.quantum = "256/48000";
          };
        }
      ];
      stream.properties = {
        resample.quality = 10;
      };
    };

    raopOpenFirewall = true;
    extraConfig.pipewire."10-airplay" = {
      "context.modules" = [
        {
        name = "libpipewire-module-raop-discover";
        }
      ];
    };
  };

  # Define the current user.
  users.users.erizur = {
    name = "Erizur";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "bluetooth" "audio" "uinput" ]; # Uinput might be unsafe, but required for some gamepad projects I use.
    home = "/home/erizur";
  };

  programs.steam = {
  	enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = true;
  };

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

  fonts.fontconfig = {
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

  system.stateVersion = "25.05"; # Don't change this unless fully reinstalling
}
