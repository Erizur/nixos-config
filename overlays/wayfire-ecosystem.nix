# Temporary local overlay tracking pr 492535 until it merges.
inputs: final: prev: {

  doctest = prev.doctest.overrideAttrs (_: {
    version = "2.5.2";
    src = prev.fetchFromGitHub {
      owner = "doctest";
      repo = "doctest";
      rev = "v2.5.2";
      hash = "sha256-4jW6xPFCFxk1l47EkSUVojhycrtluPhOc5Adf/25R7M=";
    };
  });

  wf-config = prev.wf-config.overrideAttrs (_: {
    version = "0.11.0-unstable-2026-02-20";
    src = prev.fetchFromGitHub {
      owner = "WayfireWM";
      repo = "wf-config";
      rev = "a2051f5d131a23acdcd96bfeb509d01cf57139ec";
      hash = "sha256-K6VKGeUM9pP0jHw9jIvV5vUdNYfPBldBXG82/WqbYro=";
    };
  });

  wayfire = prev.wayfire.overrideAttrs (old: {
    version = "0.11.0-unstable";
    src = inputs.wayfire-devel;
    NIX_CFLAGS_COMPILE = "${old.NIX_CFLAGS_COMPILE or ""} -I${prev.libdrm.dev}/include/libdrm";
    buildInputs = [
      prev.libGL
      prev.libdrm
      prev.libexecinfo
      prev.libevdev
      prev.libinput
      prev.libjpeg
      prev.libxml2
      prev.vulkan-headers
      prev.libxcb-wm
    ];
    propagatedBuildInputs = [
      final.wf-config
      prev.wlroots_0_20
      prev.wayland
      prev.cairo
      prev.pango
      prev.yyjson
      prev.libxkbcommon
      prev.wayland-protocols
    ];
  });

  wayfirePlugins = prev.wayfirePlugins // {

    wcm = prev.wayfirePlugins.wcm.overrideAttrs (_: {
      version = "0.11.0-unstable-2025-11-23";
      src = prev.fetchFromGitHub {
        owner = "WayfireWM";
        repo = "wcm";
        rev = "d7e3d6783f3e7d10c3c4edf556be7a5342626065";
        fetchSubmodules = true;
        hash = "sha256-O4BYwb+GOMZIn3I2B/WMJ5tUZlaegvwBuyNK9l/gxvQ=";
      };
    });

    wf-shell = prev.wayfirePlugins.wf-shell.overrideAttrs (old: {
      version = "0.11.0-unstable-2026-04-26";
      src = prev.fetchFromGitHub {
        owner = "WayfireWM";
        repo = "wf-shell";
        rev = "d340a173acfa2fe4bcf8088e154f76c43b5d4ab9";
        fetchSubmodules = true;
        hash = "sha256-I2PnrBrcD0VaxztJB6JyzfuYP6J0mXJ7ATrqgUzeCiM=";
      };
      nativeBuildInputs = old.nativeBuildInputs
        ++ [ prev.vala prev.gobject-introspection ];
      buildInputs = [
        final.wayfire
        prev.alsa-lib
        prev.gtkmm4
        prev.gtk4-layer-shell
        prev.pulseaudio
        prev.libdbusmenu-gtk3
        prev.wireplumber
        prev.libdbusmenu
        prev.libepoxy
        prev.linux-pam
        prev.pipewire
        prev.openssl
        prev.inotify-tools
        prev.libgbm
      ];
      postPatch = ''
        substituteInPlace data/meson.build \
          --replace-fail "/etc/pam.d/" "etc/pam.d"
      '';
    });

    wayfire-plugins-extra = prev.wayfirePlugins.wayfire-plugins-extra.overrideAttrs (old: {
      version = "0.11.0-unstable-2026-04-23";
      src = prev.fetchFromGitHub {
        owner = "WayfireWM";
        repo = "wayfire-plugins-extra";
        rev = "a65af2577986fbbdf8100048ad9943aff8ab27ff";
        fetchSubmodules = true;
        hash = "sha256-U6QllOwGbJQJECe1ofoiV659cLOJyIvYwqshYCCXlFg=";
      };
      buildInputs = (prev.lib.subtractLists
        [ prev.libinput prev.libxkbcommon prev.gtkmm3 ]
        old.buildInputs)
        ++ [ prev.glibmm prev.libGL ];
    });

  };
}
