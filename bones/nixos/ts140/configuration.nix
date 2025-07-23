{ config, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];

    networking.hostName = "ts140";
    environment.variables.ROC_ENABLE_PRE_VEGA = "1";
    
    hardware.graphics = {
        extraPackages = with pkgs; [ amdvlk rocmPackages.clr.icd mesa ];
        extraPackages32 = with pkgs.pkgsi686Linux; [ amdvlk mesa ];
    };

    boot.loader.grub.extraEntries = ''
        menuentry "OpenCore" {
            insmod chain
            insmod part_gpt
            insmod fat
            set root=(hd3,gpt1)
            chainloader /efi/boot/BOOTx64.efi
            set root=(hd3,gpt1)/efi
        }
    '';
}