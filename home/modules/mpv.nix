{ pkgs, lib, config, ... }:
let
  geometryFile = "${config.home.homeDirectory}/.config/mpv/geometry.conf";

  rememberWindowSize = pkgs.writeText "remember-window-size.lua" ''
    local geometry_file = "${geometryFile}"

    local function save_geometry()
      local w = mp.get_property_number("osd-width")
      local h = mp.get_property_number("osd-height")
      if w and h and w > 0 and h > 0 then
        local file = io.open(geometry_file, "w")
        if file then
          file:write(string.format("geometry=%dx%d\n", w, h))
          file:close()
        end
      end
    end

    mp.register_event("shutdown", save_geometry)
  '';
in
{
  home.activation.mpvGeometrySeed = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$(dirname "${geometryFile}")"
    [ -f "${geometryFile}" ] || echo "geometry=1280x720" > "${geometryFile}"
  '';

  programs.mpv = {
    enable = true;

    package = (
      pkgs.mpv.override {
        scripts = with pkgs.mpvScripts; [
          sponsorblock
          visualizer
          thumbfast
          modernz
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

      auto-window-resize = "no";
      keep-open = "yes";
      include = "~~/geometry.conf";
    };
  };

  home.file.".config/mpv/scripts/remember-window-size.lua".source = rememberWindowSize;
}
