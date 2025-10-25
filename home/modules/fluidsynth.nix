{ config, pkgs, ... }:
let
  inherit (config.home) homeDirectory;
in
{
  services.fluidsynth = {
    enable = true;
    extraOptions = [
        "--gain 1.0"
    ];
    soundFont = "${homeDirectory}/Music/soundfonts/default.sf2";
    soundService = "pipewire-pulse";
  };
}