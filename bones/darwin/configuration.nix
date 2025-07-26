{ config, pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-darwin";
  system.stateVersion = 6;

  # Define the current user.
  users.users.erizur = {
    name = "Erizur";
    shell = pkgs.zsh;
    home = "/Users/erizur";
  };

  homebrew = {
    enable = true;
    casks = [ "supertuxkart" "supertux" ];
  };
}