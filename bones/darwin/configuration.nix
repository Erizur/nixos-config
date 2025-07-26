{ config, pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-darwin";

  # Define the current user.
  users.users.erizur = {
    name = "Erizur";
    shell = pkgs.zsh;
    home = "/Users/erizur";
  };

  homebrew = {
    enable = true;
    casks = [ "supertuxkart" "supertux" "chromium" ];
    brewPrefix = "/opt/homebrew/bin/";
  };

  system.stateVersion = 6;
  system.primaryUser = "Erizur";
}