{
  pkgs,
  lib,
  xcursorgen,
  hicolor-icon-theme,
  jq,
  librsvg,
  bc
}:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "oxygen-cursors";
  version = "0.1";
  src = ./.;

  nativeBuildInputs = [
    xcursorgen
    jq
    librsvg
    bc
  ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  buildPhase = ''
    runHook preBuild
    SIZES="24 32 48 64"

    for theme in Oxygen-Zion; do
      mkdir -p $theme/cursors_compiled

      for dir in $theme/cursors_scalable/*; do
        if [ -d "$dir" ] && [ -f "$dir/metadata.json" ]; then
          cursor_name=$(basename "$dir")
          config_file="$dir/build.in"
          rm -f "$config_file"

          len=$(jq '. | length' "$dir/metadata.json")

          for size in $SIZES; do
            # Get the nominal size
            nom_size=$(jq -r '.[0].nominal_size' "$dir/metadata.json")

            # CALCULATE THE ZOOM MULTIPLIER (Target Size / Nominal Size)
            zoom=$(echo "scale=4; $size / $nom_size" | bc)

            for i in $(seq 0 $((len-1))); do
              svg_file=$(jq -r ".[$i].filename" "$dir/metadata.json")
              hot_x=$(jq -r ".[$i].hotspot_x" "$dir/metadata.json")
              hot_y=$(jq -r ".[$i].hotspot_y" "$dir/metadata.json")
              delay=$(jq -r ".[$i].delay // empty" "$dir/metadata.json")

              # Scale the hotspots using the zoom multiplier
              new_x=$(echo "scale=0; ($hot_x * $zoom + 0.5) / 1" | bc)
              new_y=$(echo "scale=0; ($hot_y * $zoom + 0.5) / 1" | bc)

              # Render using --zoom to preserve natural canvas proportions and shadows
              png_file="$dir/''${size}_''${i}.png"
              rsvg-convert --zoom=$zoom -f png -o "$png_file" "$dir/$svg_file"

              if [ -z "$delay" ]; then
                echo "$size $new_x $new_y $png_file" >> "$config_file"
              else
                echo "$size $new_x $new_y $png_file $delay" >> "$config_file"
              fi
            done
          done

          xcursorgen "$config_file" "$theme/cursors_compiled/$cursor_name"
        fi
      done

      rm -rf $theme/cursors
      mv $theme/cursors_compiled $theme/cursors

      # (Symlinks remain identical to before)
      for target_dir in cursors cursors_scalable; do
        pushd $theme/$target_dir
        ln -sf wait watch
        ln -sf half-busy progress
        ln -sf half-busy left_ptr_watch

        ln -sf pointing_hand hand1
        ln -sf pointing_hand hand2
        ln -sf pointing_hand pointer

        ln -sf xterm ibeam
        ln -sf xterm text

        ln -sf closedhand move
        ln -sf fleur size_all
        ln -sf fleur all-scroll

        ln -sf forbidden not-allowed
        ln -sf circle crossed_circle

        ln -sf help question_arrow
        ln -sf help whats_this

        ln -sf copy dnd-copy
        ln -sf link dnd-link

        ln -sf closedhand dnd-move
        ln -sf closedhand dnd-none
        ln -sf forbidden dnd-no-drop

        ln -sf size_ver n-resize
        ln -sf size_ver s-resize
        ln -sf size_ver ns-resize
        ln -sf size_hor e-resize
        ln -sf size_hor w-resize
        ln -sf size_hor ew-resize

        ln -sf size_fdiag nw-resize
        ln -sf size_bdiag ne-resize
        ln -sf size_bdiag sw-resize
        ln -sf size_fdiag se-resize
        ln -sf split_h col-resize
        ln -sf split_v row-resize
        ln -sf size_hor sb_h_double_arrow
        ln -sf size_ver sb_v_double_arrow
        ln -sf size_ver v_double_arrow

        ln -sf cross crosshair
        popd
      done
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for theme in Oxygen-Zion; do
      mkdir -p $out/share/icons/$theme/cursors
      mkdir -p $out/share/icons/$theme/cursors_scalable
      cp -a $theme/cursors/* $out/share/icons/$theme/cursors/
      cp -a $theme/cursors_scalable/* $out/share/icons/$theme/cursors_scalable/
      install -m644 $theme/index.theme $out/share/icons/$theme/index.theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://invent.kde.org/plasma/oxygen";
    description = "Style neutral scalable cursor theme";
    platforms = platforms.all;
    license = licenses.cc-by-sa-30;
    maintainers = [ ];
  };
}
