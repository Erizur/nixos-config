{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "AM_Erizur";
    userEmail = "sjdks@outlook.com";
    
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}