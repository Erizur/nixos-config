{ config, pkgs, ... }:
{
  services.fluidsynth = {
    enable = true;
    extraOptions = [
        "--gain 1.0"
    ];
    soundFont = "/home/erizur/Music/soundfonts/default.sf2";
    soundService = "pipewire-pulse";
  };
}