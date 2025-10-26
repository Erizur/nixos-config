{ self, config, lib, pkgs, inputs, ... }:
let
  greetDir = ../../greeter;
in
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

  # Nuke the console.
  console.enable = false;

  services.xserver = {
  	enable = true;
    xkb.layout = "es";
  };

  services.kmscon = {
    enable = true;
    fonts = [ { name = "JetBrainsMono Nerd Font"; package = pkgs.nerd-fonts.jetbrains-mono; } ];
    hwRender = true;
    useXkbConfig = true;
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

  programs.steam = {
  	enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = true;
  };

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  # TODO: Move this around a new file, to declutter?
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "env GREET_WALLPATH='/home/erizur/Pictures/Wallpapers/wp10550609.jpg' GREET_UPICPATH='/home/erizur/Downloads/image.png' XDG_SESSION_TYPE=wayland EGL_PLATFORM=gbm QT_QPA_PLATFORM=wayland QT_WAYLAND_DISABLE_WINDOWDECORATION=1 cage -s -- quickshell -p ${greetDir}/greet.qml";
      };
    };
  };

  security.pam.services.greetd.text = ''
  auth      substack      login
  account   include       login
  password  substack      login
  session   include       login
  '';

  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
  ];
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
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-tokyonight
          fcitx5-gtk
        ];
        waylandFrontend = true;
      };
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

  virtualisation.docker = {
      enable = false;
      rootless = {
          enable = true;
          setSocketVariable = true;
          daemon.settings = {
              dns = ["1.1.1.1" "8.8.8.8"];
              registry-mirrors = ["https://mirror.gcr.io"];
          };
      };
  };
  
  hardware.opentabletdriver.enable = true;

  system.stateVersion = "25.05"; # Don't change this unless fully reinstalling
}
