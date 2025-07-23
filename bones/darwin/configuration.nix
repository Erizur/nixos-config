{ config, pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-darwin";

  # Define the current user.
  users.users.erizur = {
    name = "erizur";
    shell = pkgs.zsh;
    home = "/Users/erizur";
  };

  homebrew = {
    enable = true;
  };
}