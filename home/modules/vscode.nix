{ config, pkgs, ... }:
{
	home.file = {
		".local/share/vscode-paths/jdk21".source = pkgs.jdk21;
		".local/share/vscode-paths/vscode-lldb".source = pkgs.vscode-extensions.vadimcn.vscode-lldb;
		".config/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixcfg/home/vscode-settings.json";
	};

	programs.vscode = {
		enable = true;
		profiles.default = {
			extensions = with pkgs.vscode-marketplace-universal; [
				ms-vscode.cpptools-extension-pack
                ms-vscode.cmake-tools

				ms-python.python
                ms-python.vscode-pylance
                ms-python.debugpy
                ms-python.black-formatter

                llvm-vs-code-extensions.vscode-clangd
                vadimcn.vscode-lldb

                rust-lang.rust-analyzer
                ziglang.vscode-zig

				redhat.java
				vscjava.vscode-java-debug
				vscjava.vscode-java-test
				vscjava.vscode-maven
				vscjava.vscode-gradle
				vscjava.vscode-java-dependency
				
				vmware.vscode-spring-boot
				vscjava.vscode-spring-initializr
                vscjava.vscode-spring-boot-dashboard

                msjsdiag.vscode-react-native
                dsznajder.es7-react-js-snippets
                expo.vscode-expo-tools

                pkgs.vscode-extensions.ms-dotnettools.csharp
                pkgs.vscode-extensions.ms-dotnettools.vscode-dotnet-runtime 
                pkgs.vscode-extensions.ms-dotnettools.csdevkit
                pkgs.vscode-extensions.visualstudiotoolsforunity.vstuc

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

                theqtcompany.qt-qml

				tomoki1207.pdf
				enkia.tokyo-night
			];
		};
	};
}
