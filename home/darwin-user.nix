{ config, pkgs, system, inputs, ... }: 
{
  home.username = "erizur";
  home.stateVersion = "25.05";
  
  imports = [
    ./modules
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = with pkgs; [
    vesktop
    zoom-us
    obsidian

    nil
    alejandra
    pyright

    cmake-language-server

    duckstation
    pcsx2-bin
    ares
    prismlauncher
    scummvm
    mame
    
    any-nix-shell
  ];

  targets.darwin.linkApps.directory = "Applications";
  programs.home-manager.enable = true;
}
