{ config, pkgs, ... }:
{
	programs.vscode = {
		enable = true;
		profiles.default.extensions = with pkgs.vscode-extensions; [
			ms-vscode.cpptools
			ms-python.python

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
			
			vscode-extensions.asvetliakov.vscode-neovim
		];
	};
}
