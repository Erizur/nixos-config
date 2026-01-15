{ pkgs, lib, config, ... }:
{
  programs.mpv = {
    enable = true;

    package = (
      pkgs.mpv.override {
        scripts = with pkgs.mpvScripts; [
          sponsorblock
          visualizer
          thumbfast
          mpv-discord
          mpv-osc-modern
          memo
        ] ++ lib.optionals pkgs.stdenv.isLinux [ mpris ];

        mpv-unwrapped = pkgs.mpv-unwrapped.override {
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
