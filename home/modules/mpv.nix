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
          mpv-osc-modern
          memo
        ] ++ lib.optionals pkgs.stdenv.isLinux [ mpris ];

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
      osc = "no";
      osc-bar = "no";
    };
  };
}