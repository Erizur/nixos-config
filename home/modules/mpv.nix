{ pkgs, lib, config, ... }:
{
  programs.mpv = {
    enable = true;

    package = (
      pkgs.mpv-unwrapped.wrapper {
        scripts = with pkgs.mpvScripts; [
          uosc
          sponsorblock
          visualizer
          thumbfast
          mpv-discord
          mpris
          mpv-osc-modern
          memo
        ];

        mpv = pkgs.mpv-unwrapped.override {
          waylandSupport = if pkgs.stdenv.isLinux then true else false;
          ffmpeg = pkgs.ffmpeg-full;
        };
      }
    );

    config = {
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio";
      cache-default = 4000000;
      osd = "no";
      osd-bar = "no";
    };
  };
}