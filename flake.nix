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
        git
      ];

      plugins = with pkgs.vimPlugins; [
        blink-cmp
        plenary-nvim
        base16-nvim
        telescope-nvim
        undotree
        vim-slime
        nvim-treesitter.withAllGrammars
      ];

      nvim = pkgs.neovim.override {
        withPython3 = false;
        withNodeJs = false;
        withRuby = false;
        viAlias = false;

        configure.customRC = config;
        configure.packages = {
          _ = {
            start = plugins;
          };
        };
      };
    in
    {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        name = "nvim";
        src = nvim;
        nativeBuildInputs = with pkgs; [ makeWrapper ];
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
