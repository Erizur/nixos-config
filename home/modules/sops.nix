{ config, inputs, ... }:
{
  sops = {
    defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets = {
      "element/reckey" = { path = "${config.home.homeDirectory}/.config/element_rk"; };
      "git/private_key" = { };
    };
  };
}
