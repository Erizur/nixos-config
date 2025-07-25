{ config, pkgs, ... }:
{
	programs.zsh.shellAliases.nixcgrs = "sudo nixos-rebuild switch --flake ~/.nixcfg#sjdks";

	programs.fastfetch = {
		enable = true;
		settings = {
			modules =  [
				"title"
				"separator"
				"os"
				"host"
				"kernel"
				"uptime"
				"packages"
				"shell"
				"de"
				"wm"
				"wmtheme"
				"font"
				"cpu"
				"gpu"
				"memory"
				"disk"
				"battery"
				"break"
				"colors"
			];
			logo = {
				source = "${config.home.homeDirectory}/.nixcfg/img/pitcher56.jpg";
				type = "chafa";
			};
		};
	};
}
