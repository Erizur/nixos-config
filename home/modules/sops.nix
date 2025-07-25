{ config, inputs, ... }:
{
  sops = {
    defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
    age.keyFile = [ "${config.home.homeDirectory}/.config/sops/age/keys.txt" ];

    secrets = {
      "git/private_key" = { };
    };
  };
}