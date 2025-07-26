{ config, pkgs, ... }:
{
	programs.zsh.shellAliases.nixcgrs = if pkgs.stdenv.isLinux then "sudo nixos-rebuild switch --flake ~/.nixcfg#ts140" else "sudo darwin-rebuild switch --flake ~/.nixcfg#ts140";
	programs.fastfetch.settings.logo = {
		source = "${config.home.homeDirectory}/.nixcfg/img/makoto.jpg";
		type = "chafa";
	};
}
