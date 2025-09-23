{ config, pkgs, ... }:
{
	programs.vscode = {
		enable = true;
		profiles.default = {
			extensions = with pkgs.vscode-marketplace; [
				ms-vscode.cpptools-extension-pack
				ms-vscode.cmake-tools
				ms-python.python
				ms-python.vscode-pylance

				llvm-vs-code-extensions.vscode-clangd
				pkgs.vscode-extensions.vadimcn.vscode-lldb

				rust-lang.rust-analyzer

				pkgs.vscode-extensions.redhat.java
				vscjava.vscode-java-debug
				vscjava.vscode-java-test
				vscjava.vscode-maven
				vscjava.vscode-gradle
				vscjava.vscode-java-dependency
				
				vmware.vscode-spring-boot
				vscjava.vscode-spring-initializr
				vscjava.vscode-spring-boot-dashboard

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

				nadako.vshaxe
				wiggin77.codedox
				vshaxe.haxe-checkstyle
				vshaxe.haxe-debug
				vshaxe.hxcpp-debugger
				openfl.lime-vscode-extension
				
				asvetliakov.vscode-neovim
				vscode-icons-team.vscode-icons

				davidanson.vscode-markdownlint
				redhat.vscode-yaml
				redhat.vscode-xml

				tomoki1207.pdf
				enkia.tokyo-night
			];

			userSettings = {
				"editor.formatOnSave" = false;
				"editor.fontFamily" = "'JetBrains Mono Nerd Font', 'monospace', monospace";
				"workbench.colorTheme" = "Tokyo Night Storm";
				"workbench.iconTheme"= "vscode-icons";
				"extensions.experimental.affinity" = {
					"asvetliakov.vscode-neovim" = 1;
				};
				"C_Cpp.intelliSenseEngine" = "disabled";
				"redhat.telemetry.enabled" = false;
				"java.jdt.ls.java.home" = "${pkgs.jdk21}/lib/openjdk";
				"spring-boot.ls.java.home" = "${pkgs.jdk21}/lib/openjdk";
                "maven.terminal.useJavaHome" = true;
                "lldb.library" = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/lldb/lib/liblldb.so";
			};
		};
	};
}
