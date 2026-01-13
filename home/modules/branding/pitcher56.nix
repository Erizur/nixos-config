{ config, pkgs, ... }:
{
	programs.zsh.shellAliases.nixcgrs = "sudo nixos-rebuild switch --flake ~/.nixcfg#sajou";
	programs.fastfetch.settings.logo = {
		source = "${config.home.homeDirectory}/.nixcfg/img/pitcher56.jpg";
		type = "chafa";
	};
}
