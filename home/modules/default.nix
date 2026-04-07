{ config, pkgs, ...}:
{
  imports = [
    ./zsh.nix
    ./mpv.nix
    ./obs.nix
    ./vscode.nix
    ./sops.nix
    ./git.nix
    ./fastfetch.nix
    ./kitty.nix
    ./wayfire.nix
    ./nvim/default.nix
  ];

  programs.java.enable = true;
}
