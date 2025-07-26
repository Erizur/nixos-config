{ config, pkgs, ...}:
{
  imports = [
    ./zsh.nix
    ./mpv.nix
    ./vscode.nix
    ./sops.nix
    ./git.nix
    ./fastfetch.nix
    ./nvim/default.nix
  ];
}