{ config, pkgs, ... }:
{
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		shellAliases = {
			ll = "ls -l";
			nixcgrs = "sudo nixos-rebuild switch --flake ~/.nixcfg#ts140";
			editnixcfg = "sudoedit ~/.nixcfg/bones/configuration.nix";
			editnixflake = "sudoedit ~/.nixcfg/flake.nix";
			editnixhome = if pkgs.stdenv.isLinux then "sudoedit ~/.nixcfg/home/main-user.nix" else "sudoedit ~/.nixcfg/home/darwin-user.nix";
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
