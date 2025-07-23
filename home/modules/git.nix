{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    package = pkgs.gitFull;

    userName = "AM_Erizur";
    userEmail = "sjdks@outlook.com";
    
    extraConfig = {
      credential = {
        helper = "manager";
        "https://github.com".username = "Erizur";
        credentialStore = "cache";
      };
      init.defaultBranch = "main";
    };
  };
}