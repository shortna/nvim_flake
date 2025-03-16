{
	description = "nvim flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
	};

	outputs =
	{ self, nixpkgs }:
	let
		system = "x86_64-linux";

	configFiles = builtins.map (x: "luafile" + x) (pkgs.lib.filesystem.listFilesRecursive ./nvim);
	config = builtins.concatStringsSep "\n" configFiles;

	pkgs = import nixpkgs {
		inherit system;
	};

	runtimeDeps = with pkgs; [
		ripgrep
		fd
		clang
		git
	];

	plugins = with pkgs.vimPlugins; [
		nvim-lspconfig
		nvim-cmp
		cmp-nvim-lsp
		cmp-path
		cmp-buffer
		vim-airline
		plenary-nvim
		telescope-nvim
		vim-fugitive
		undotree
		vim-slime
		catppuccin-nvim
		nvim-treesitter.withAllGrammars
	];

	nvim = pkgs.neovim.override {
		withPython3 = false;
		withNodeJs = false;
		withRuby = false;
		viAlias = true;

		configure.customRC = config;
		configure.packages = { _ = { start = plugins; }; };
	};
	in
	{
		devShells.${system}.default = pkgs.stdenv.mkDerivation {
			name = "nvim";
			buildInputs = [nvim] ++ runtimeDeps;
		};
		packages.${system}.default = pkgs.stdenv.mkDerivation {
			name = "nvim";
			src = nvim;
			nativeBuildInputs = with pkgs; [makeWrapper];
			installPhase = ''
				runHook preInstall
				mkdir -p $out/bin
				cp ${nvim}/bin/nvim $out/bin
				runHook postInstall
				'';
# https://nixos.org/manual/nixpkgs/unstable/#ssec-stdenv-dependencies-overview
# see example
			postInstall = '' 
				wrapProgram $out/bin/nvim \
				--prefix PATH : ${pkgs.lib.makeBinPath runtimeDeps}
			'';
		};

	};
}
