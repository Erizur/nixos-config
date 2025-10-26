{ self, config, pkgs, system, inputs, extraGaming, ... }:
let 
  duckstation-src = import inputs.duckstation-unofficial {system = "${system}"; config.allowUnfree = true;};
  cursor-path = ../cursor;
in
{
  home.username = "erizur";
  home.homeDirectory = "/home/erizur";
  home.stateVersion = "25.05";
  
  imports = [
    ./modules
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = with pkgs; [
    lutris
    (bottles.override {
      extraLibraries = pkgs: [
        pkgs.fluidsynth
      ];
    })
	
    inputs.marble-browser.packages."${system}".default
    chromium
    vesktop
    zoom-us
    
    obsidian
    onlyoffice-desktopeditors
    cider-2
    
    obs-studio

    superTuxKart
    superTux
    pingus
    pcsx2
    prismlauncher
    duckstation-src.duckstation
    
    any-nix-shell
  ] ++ lib.optionals (extraGaming == true) [
    teeworlds hedgewars
    ares
    rmg-wayland
    dolphin-emu
    mame scummvm
  ];

  home.pointerCursor = {
          gtk.enable = true;
          x11.enable = true;
          name = "Oxygen-Zion";
          size = 24;
          package = 
            pkgs.runCommand "moveUp" {} ''
              mkdir -p $out/share/icons
              cp -r ${cursor-path} $out/share/icons/Oxygen-Zion
              chmod -R u+w $out/share/icons/Oxygen-Zion
              cd $out/share/icons/Oxygen-Zion/cursors
              for dir in cursors cursors_scalable; do
                test -d "$out/share/icons/Oxygen-Zion/$dir" || continue
                cd "$out/share/icons/Oxygen-Zion/$dir"

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
                ln -sf size_hor e-resize
                ln -sf size_hor w-resize
                ln -sf size_bdiag nw-resize
                ln -sf size_fdiag ne-resize
                ln -sf size_fdiag sw-resize
                ln -sf size_bdiag se-resize
                ln -sf size_hor col-resize
                ln -sf size_ver row-resize
                ln -sf size_hor sb_h_double_arrow
                ln -sf size_ver sb_v_double_arrow
                ln -sf size_hor v_double_arrow

                ln -sf cross crosshair
                ln -sf split_h sb_h_double_arrow
                ln -sf split_v sb_v_double_arrow
              done          
          '';
        };
  programs.home-manager.enable = true;
}

