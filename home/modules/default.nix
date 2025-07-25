{ config, pkgs, ...}:
{
  imports = [
    ./zsh.nix
    ./mpv.nix
    ./vscode.nix
    ./sops.nix
    ./git.nix
    ./nvim/default.nix
  ];
}