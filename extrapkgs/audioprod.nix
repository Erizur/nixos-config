{ config, lib, pkgs, ... }:

with lib;

# Base config for all Linux systems
# Taken from: https://github.com/polygon/dotfiles/blob/master/modules/audioprod.nix

let
  cfg = config.modules.apps.audioprod;
in
{
  options.modules.apps.audioprod.enable = mkEnableOption "Audio Production Applications";

  config = mkIf cfg.enable {
    environment.variables = {
      LV2_PATH = "/run/current-system/sw/lib/lv2";
    };

    environment.pathsToLink = [ "/lib/vst2" "/lib/vst3" "/lib/clap" ];

    environment.systemPackages = with pkgs; [
      distrho-ports
      geonkick
      x42-plugins
      dragonfly-reverb
      faustPhysicalModeling
      quadrafuzz
      calf
      lsp-plugins
      carla
      drumgizmo
      bitwig-studio
      bespokesynth
      sonic-visualiser
      zenity
      stochas
      xtuner
      atlas2
      paulxstretch
      vital
      tony
      amplocker
      chow-centaur
      chow-phaser
      papu
      kmidimon
      ripplerx
      decent-sampler
      mucap
    ];

    security.pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"   ; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio" ; type = "-"   ; value = "99"       ; }
      { domain = "@audio"; item = "nofile" ; type = "soft"; value = "99999"    ; }
      { domain = "@audio"; item = "nofile" ; type = "hard"; value = "99999"    ; }
    ];

    services.udev.extraRules = ''
      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"
    '';
  };
}
