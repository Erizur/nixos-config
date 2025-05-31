{ config, pkgs, ... }:
{
	programs.vscode = {
		enable = true;
		extensions = with pkgs.vscode-extensions; [
			ms-vscode.cpptools
			ms-python.python

			llvm-vs-code-extensions.vscode-clangd
			vadimcn.vscode-lldb

			rust-lang.rust-analyzer

			bbenoist.nix
			brettm12345.nixfmt-vscode

			ms-vscode.live-server
			mkhl.direnv
		];
	};
}
