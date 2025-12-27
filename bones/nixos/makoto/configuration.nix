{ config, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];

    networking.hostName = "makoto";
    services.lact.enable = true;
    hardware.amdgpu.opencl.enable = true;

    programs.gamescope.enable = true;
    programs.gamemode.enable = true;

    programs.coolercontrol.enable = true;
}
