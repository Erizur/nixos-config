{ config, pkgs, ...}:
{
  imports = [
    ./zsh.nix
    ./mpv.nix
    ./vscode.nix
    ./sops.nix
    ./git.nix
    ./fastfetch.nix
    ./kitty.nix
    ./nvim/default.nix
  ];
}