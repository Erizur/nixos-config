{ config, pkgs, ... }:
{
	programs.zsh.shellAliases.nixcgrs = if pkgs.stdenv.isLinux then "sudo nixos-rebuild switch --flake ~/.nixcfg#ts140" else "sudo darwin-rebuild switch --flake ~/.nixcfg#ts140";

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
				"break"
				"colors"
			];
			logo = {
				source = "${config.home.homeDirectory}/.nixcfg/img/makoto.jpg";
				type = "chafa";
			};
		};
	};
}
