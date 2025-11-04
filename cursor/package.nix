{
  pkgs,
  lib,
  xorg,
  hicolor-icon-theme,
}:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "oxygen-cursors";
  version = "0.1";

  src = ./.; 

  buildInputs = [
    xorg.xcursorgen
  ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  buildPhase = ''
    runHook preBuild

    for theme in Oxygen-Zion; do
      for dir in cursors cursors_scalable; do
        pushd $theme/$dir
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
