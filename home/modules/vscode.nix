{ config, pkgs, lib, ... }:
let
	ext = pkgs.vscode-marketplace-universal;

	# jupyter is recursively searching through my temp folder
	jupyter-fixed = ext.ms-toolsai.jupyter.overrideAttrs (old: {
		postInstall = (old.postInstall or "") + ''
		rm -f "$out/share/vscode/extensions/ms-toolsai.jupyter/temp"
		'';
	});

	commonExtensions = with ext; [
		bbenoist.nix
		jnoortheen.nix-ide
		brettm12345.nixfmt-vscode

		esbenp.prettier-vscode
		editorconfig.editorconfig
		davidanson.vscode-markdownlint
		redhat.vscode-yaml
		redhat.vscode-xml

		mkhl.direnv
		ms-vsliveshare.vsliveshare
		wiggin77.codedox
		tomoki1207.pdf

		asvetliakov.vscode-neovim
		vscode-icons-team.vscode-icons
		enkia.tokyo-night
	];

	cppPythonExtensions = with ext; [
		ms-vscode.cpptools-extension-pack
		ms-vscode.cmake-tools
		llvm-vs-code-extensions.vscode-clangd
		vadimcn.vscode-lldb
		ms-vscode.makefile-tools
		theqtcompany.qt-qml

		ms-python.python
		ms-python.vscode-pylance
		ms-python.debugpy
		ms-python.black-formatter
		jupyter-fixed
		ms-toolsai.jupyter-renderers
	];

	rustZigExtensions = with ext; [
		rust-lang.rust-analyzer
		ziglang.vscode-zig
	];

	javaSpringExtensions = with ext; [
		redhat.java
		vscjava.vscode-java-debug
		vscjava.vscode-java-test
		vscjava.vscode-maven
		vscjava.vscode-gradle
		vscjava.vscode-java-dependency
		vmware.vscode-spring-boot
		vscjava.vscode-spring-initializr
		vscjava.vscode-spring-boot-dashboard
	];

	webExtensions = with ext; [
		msjsdiag.vscode-react-native
		dsznajder.es7-react-js-snippets
		expo.vscode-expo-tools
		vitest.explorer
		vue.volar
		dbaeumer.vscode-eslint
		ms-vscode.live-server
	];

	haxeExtensions = with ext; [
		nadako.vshaxe
		vshaxe.haxe-checkstyle
		vshaxe.haxe-debug
		vshaxe.hxcpp-debugger
		openfl.lime-vscode-extension
	];

	writableProfileNames = [ "cpp-python" "rust-zig" "java-spring" "web" "haxe" ];

	settingsRepoDir = "${config.home.homeDirectory}/.nixcfg/home/vscode-settings";
	defaultSettingsFile = "${config.home.homeDirectory}/.nixcfg/home/vscode-settings.json";
	storageJson = "${config.home.homeDirectory}/.config/Code/User/globalStorage/storage.json";
	profilesDir = "${config.home.homeDirectory}/.config/Code/User/profiles";

	linkOneProfile = name: ''
		if [ -f "${storageJson}" ]; then
			id="$(${pkgs.jq}/bin/jq -r --arg n "${name}" \
				'.userDataProfiles[]? | select(.name==$n) | .location' \
				"${storageJson}")"
			if [ -n "$id" ] && [ "$id" != "null" ]; then
				mkdir -p "${profilesDir}/$id"
				mkdir -p "${settingsRepoDir}"
				[ -f "${settingsRepoDir}/${name}.json" ] || echo '{}' > "${settingsRepoDir}/${name}.json"
				$DRY_RUN_CMD ln -sf "${settingsRepoDir}/${name}.json" "${profilesDir}/$id/settings.json"
			else
				echo "vscode profile '${name}': not created in VS Code yet, skipping settings symlink" >&2
			fi
		fi
	'';
in
{
	home.packages = [ pkgs.jq ];

	home.file = {
		".local/share/vscode-paths/jdk21".source = pkgs.jdk21;
		".local/share/vscode-paths/vscode-lldb".source = pkgs.vscode-extensions.vadimcn.vscode-lldb;

		".config/Code/User/settings.json".source =
			config.lib.file.mkOutOfStoreSymlink defaultSettingsFile;
	};

	home.activation.vscodeProfileSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
		mkdir -p "$(dirname "${defaultSettingsFile}")"
		[ -f "${defaultSettingsFile}" ] || echo '{}' > "${defaultSettingsFile}"
		${lib.concatMapStringsSep "\n" linkOneProfile writableProfileNames}
	'';

	programs.vscode = {
		enable = true;

		profiles = {
			default.extensions = commonExtensions;
			cpp-python.extensions = commonExtensions ++ cppPythonExtensions;
			rust-zig.extensions = commonExtensions ++ rustZigExtensions;
			java-spring.extensions = commonExtensions ++ javaSpringExtensions;
			web.extensions = commonExtensions ++ webExtensions;
			haxe.extensions = commonExtensions ++ haxeExtensions;
		};
	};
}
