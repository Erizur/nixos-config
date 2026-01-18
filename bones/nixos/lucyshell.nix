{ self, config, lib, pkgs, inputs, ... }:
{
  programs.wayfire = {
    enable = true;
    plugins = with pkgs.wayfirePlugins; [
      wcm
      wf-shell
      wayfire-plugins-extra
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-wlr
    ];

    config = {
      common = {
        default = [ "kde" ];
      };
      wayfire = {
        default = [ "wlr" "kde" ];
      };
    };
  };
}
