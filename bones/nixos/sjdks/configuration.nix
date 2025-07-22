{ config, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];

    networking.hostName = "sjdks";

    hardware = {
        nvidia = {
            modesetting.enable = true;
            powerManagement = {
                enable = false;
                finegrained = false;
            };

            open = false;  # Use the proprietary NVIDIA driver
            nvidiaSettings = true; # Enable NVIDIA settings tool
            package = config.boot.kernelPackages.nvidiaPackages.stable; # Use beta NVIDIA driver
        };
    };
}