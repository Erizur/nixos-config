{ self, config, lib, pkgs, inputs, ... }:
let
  greetDir = ../../greeter;
  executeLaunch = pkgs.writeShellScript "start-greet.sh" ''
    quickshell -p ${greetDir}/greet.qml > /tmp/quickshell.log 2>&1 
  '';
  wf-log = let 
    wfIni = (pkgs.formats.ini {}).generate "wayfire.ini" {
      core = {
        plugins = "autostart foreign-toplevel";
        vheight = 1;
        vwidth = 1;
        xwayland = false;
        preferred_decoration_mode = "server";
      };
      autostart = {
        autostart_wf_shell = false;
        dm = "${executeLaunch} && wayland-logout";
      };
    };
  in "${lib.getExe pkgs.wayfire} --config ${wfIni} > /tmp/wf-log.log 2>&1";
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          env GREET_WALLPATH='/home/erizur/Pictures/Wallpapers/wp10550609.jpg' \
          GREET_UPICPATH='/home/erizur/Downloads/image.png' \
          XDG_SESSION_TYPE=wayland \
          EGL_PLATFORM=gbm \
          QT_QPA_PLATFORM=wayland \
          QT_WAYLAND_DISABLE_WINDOWDECORATION=1 \
          dbus-run-session ${wf-log}
        '';
      };
    };
  };
  
  security.pam.services.greetd.text = '' 
    auth      substack    login
    auth      optional    ${pkgs.kdePackages.kwallet-pam}/lib/security/pam_kwallet5.so
    account   include     login
    password  substack    login
    session   include     login
    session   optional    ${pkgs.kdePackages.kwallet-pam}/lib/security/pam_kwallet5.so auto_start force_run
  '';

  security.pam.services.login.kwallet.enable = true;
  security.pam.services.greetd.kwallet.enable = true;

  users.users.greeter.createHome = true;
  users.users.greeter.home = "/var/lib/greeter";
  users.users.greeter.extraGroups = ["video"];
}
