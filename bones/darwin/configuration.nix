{ config, pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-darwin";

  # Define the current user.
  users.users.erizur = {
    shell = pkgs.zsh;
    home = "/Users/erizur";
  };

  homebrew = {
    enable = true;
    casks = [ "supertuxkart" "supertux" "chromium" ];
    brewPrefix = "/opt/homebrew/bin/";
  };

  system.stateVersion = 6;
  system.primaryUser = "erizur";
  
  nixpkgs.overlays = [
    (import ./overlays.nix)
  ];
}
