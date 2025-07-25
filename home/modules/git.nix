{ config, pkgs, ... }:
let
  inherit (config.home) homeDirectory;
in
{
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    package = pkgs.gitFull;

    userName = "AM_Erizur";
    userEmail = "sjdks@outlook.com";
    
    extraConfig = {
      init.defaultBranch = "main";

      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "${homeDirectory}/.ssh/sign_ed25519.pub";
    };
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    addKeysToAgent = "yes";

    matchBlocks =
      {
        "github.com" = {
          identitiesOnly = true;
          identityFile = "${homeDirectory}/.ssh/id_ed25519";
        };
      };
  };

  services.ssh-agent = {
    enable = true;
  };
}