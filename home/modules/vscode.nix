{ config, pkgs, ... }:
{
	programs.vscode = {
		enable = true;
		profiles.default = {
			extensions = with pkgs.vscode-marketplace; [
				ms-vscode.cpptools-extension-pack
				ms-python.python
				ms-python.vscode-pylance

				llvm-vs-code-extensions.vscode-clangd
				vadimcn.vscode-lldb

				rust-lang.rust-analyzer

				bbenoist.nix
				brettm12345.nixfmt-vscode
				jnoortheen.nix-ide

				esbenp.prettier-vscode
				ms-toolsai.jupyter
				ms-toolsai.jupyter-renderers
				dbaeumer.vscode-eslint

				ms-vscode.live-server
				mkhl.direnv

				ms-vscode.makefile-tools
				ms-vsliveshare.vsliveshare

				vshaxe.haxe-extension-pack
				openfl.lime-vscode-extension
				
				asvetliakov.vscode-neovim
			];

			userSettings = {
				"editor.formatOnSave" = false;
				"editor.fontFamily" = "'JetBrains Mono Nerd Font', 'monospace', monospace";
				"workbench.colorTheme" = "Tomorrow Night Blue";
			};
		};
	};
}
