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
    
    settings = {
      user.name = "AM_Erizur";
      user.email = "watchdoukyuusei@outlook.com";
      init.defaultBranch = "main";
      commit.signoff = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "${homeDirectory}/.ssh/sign_ed25519.pub";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks =
      {
        "*" = {
          forwardAgent = true;
          addKeysToAgent = "yes";
        };

        "github.com" = {
          identitiesOnly = true;
          identityFile = "${homeDirectory}/.ssh/id_ed25519";
        };

        "amerizur.com" = {
          identitiesOnly = true;
          identityFile = "${homeDirectory}/.ssh/id_ed25519";
        };
      };
  };

  services.ssh-agent = {
    enable = if pkgs.stdenv.isLinux then true else false;
  };
}
