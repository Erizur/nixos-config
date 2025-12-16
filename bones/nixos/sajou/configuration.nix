{ config, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];

    networking.hostName = "sajou";
    networking.firewall = {
        allowedTCPPorts = [80 8000 53 5300];
        allowedUDPPorts = [53 5300];
        extraCommands = ''
            iptables -A PREROUTING -t nat -i eth0 -p TCP --dport 80 -j REDIRECT --to-port 8000
            iptables -A PREROUTING -t nat -i eth0 -p TCP --dport 53 -j REDIRECT --to-port 5300
            iptables -A PREROUTING -t nat -i eth0 -p UDP --dport 53 -j REDIRECT --to-port 5300
        '';
    };

    boot.kernel.sysctl = {
        "net.ipv4.conf.eth0.forwarding" = 1;
    };

    hardware = {
        nvidia = {
            modesetting.enable = true;
            powerManagement = {
                enable = false;
                finegrained = false;
            };

            open = false;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
    };
}
