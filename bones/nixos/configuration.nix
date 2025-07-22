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
  	hardwareClockInLocalTime = true;
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
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "bluetooth" "audio" "uinput" ]; # Uinput might be unsafe, but required for some gamepad projects I use.
    home = "/home/erizur";
  };
}