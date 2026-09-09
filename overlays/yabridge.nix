final: prev:
let
  yabridgePatchDir = "${prev.path}/pkgs/by-name/ya/yabridge";

  # subprojects/*.wrap — only asio's revision changed vs the 5.1.1 release
  asio = prev.fetchFromGitHub {
    owner = "chriskohlhoff";
    repo = "asio";
    tag = "asio-1-34-2";
    hash = prev.lib.fakeHash; # nix will tell you the real one on first build
  };
  bitsery = prev.fetchFromGitHub {
    owner = "fraillt"; repo = "bitsery"; tag = "v5.2.3";
    hash = "sha256-rmfcIYCrANycFuLtibQ5wOPwpMVhpTMpdGsUfpR3YsM=";
  };
  clap = prev.fetchFromGitHub {
    owner = "free-audio"; repo = "clap"; tag = "1.1.9";
    hash = "sha256-z2P0U2NkDK1/5oDV35jn/pTXCcspuM1y2RgZyYVVO3w=";
  };
  function2 = prev.fetchFromGitHub {
    owner = "Naios"; repo = "function2"; tag = "4.2.3";
    hash = "sha256-+fzntJn1fRifOgJhh5yiv+sWR9pyaeeEi2c1+lqX3X8=";
  };
  ghc_filesystem = prev.fetchFromGitHub {
    owner = "gulrak"; repo = "filesystem"; tag = "v1.5.14";
    hash = "sha256-XZ0IxyNIAs2tegktOGQevkLPbWHam/AOFT+M6wAWPFg=";
  };
  tomlplusplus = prev.fetchFromGitHub {
    owner = "marzer"; repo = "tomlplusplus"; tag = "v3.4.0";
    hash = "sha256-h5tbO0Rv2tZezY58yUbyRVpsfRjY3i+5TPkkxr6La8M=";
  };
  vst3 = prev.fetchFromGitHub {
    owner = "robbert-vdh"; repo = "vst3sdk"; tag = "v3.7.7_build_19-patched";
    fetchSubmodules = true;
    hash = "sha256-LsPHPoAL21XOKmF1Wl/tvLJGzjaCLjaDAcUtDvXdXSU=";
  };
in
{
  yabridge = prev.yabridge.overrideAttrs (old: {
    version = "5.1.1-unstable-2026-04-26";

    src = prev.fetchFromGitHub {
      owner = "robbert-vdh";
      repo = "yabridge";
      rev = "ba7022df0aee1e91cde62d7f0e940d3bc43a82b0";
      hash = prev.lib.fakeHash; # nix will tell you the real one on first build
    };

    # The 32-bit-drop patch is already merged upstream on this branch, so
    # only the two Nix-specific patches are needed.
    patches = [
      (prev.replaceVars "${yabridgePatchDir}/hardcode-dependencies.patch" {
        libdbus = prev.dbus.lib;
        wine = prev.wineWow64Packages.yabridge;
      })
      "${yabridgePatchDir}/libyabridge-from-nix-profiles.patch"
    ];

    postUnpack = ''
      (
        cd "$sourceRoot/subprojects"
        cp -R --no-preserve=mode,ownership ${asio} asio
        cp -R --no-preserve=mode,ownership ${bitsery} bitsery
        cp -R --no-preserve=mode,ownership ${clap} clap
        cp -R --no-preserve=mode,ownership ${function2} function2
        cp -R --no-preserve=mode,ownership ${ghc_filesystem} ghc_filesystem
        cp -R --no-preserve=mode,ownership ${tomlplusplus} tomlplusplus
        cp -R --no-preserve=mode,ownership ${vst3} vst3
      )
    '';
  });
}
