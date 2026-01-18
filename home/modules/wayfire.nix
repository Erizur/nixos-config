{ config, pkgs, lib, ... }:
let
  nixcfgDir = "${config.home.homeDirectory}/.nixcfg";
in
{
  xdg.configFile."wayfire.ini".source = config.lib.file.mkOutOfStoreSymlink "${nixcfgDir}/lucyshell/wayfire.ini";
  xdg.configFile."lucyshell".source = config.lib.file.mkOutOfStoreSymlink "${nixcfgDir}/lucyshell";
}
