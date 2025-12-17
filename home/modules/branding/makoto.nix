{ config, pkgs, ... }:
{
	programs.zsh.shellAliases.nixcgrs = if pkgs.stdenv.isLinux then "sudo nixos-rebuild switch --flake ~/.nixcfg#makoto" else "sudo darwin-rebuild switch --flake ~/.nixcfg#makoto";
	programs.fastfetch.settings.logo = {
		source = "${config.home.homeDirectory}/.nixcfg/img/makoto.png";
		type = "chafa";
	};
}
