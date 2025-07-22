{ config, pkgs, ... }:
{
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		shellAliases = {
			ll = "ls -l";
			nixcgrs = "sudo nix-collect-garbage -d && sudo nixos-rebuild switch --flake ~/.nixconfig/";
			editnixcfg = "sudoedit ~/.nixconfig/configuration.nix";
			editnixflake = "sudoedit ~/.nixconfig/flake.nix";
			editnixhome = "sudoedit ~/.nixconfig/home.nix";
		};

		oh-my-zsh = {
			enable = true;
			plugins = [ "git" "gh" "dirhistory" "history" "qrcode" "emoji" "emoji-clock" "lol" "themes"];
			theme = "candy";
		};

		initContent = ''
			any-nix-shell zsh --info-right | source /dev/stdin
			fortune | cowsay
		'';

		history.size = 1000;
	};
}
