{ config, pkgs, inputs, extraGaming, ... }:
{
  imports = [
    inputs.aagl.nixosModules.default
  ];

  programs.sleepy-launcher.enable = extraGaming;
}
