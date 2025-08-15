{
	description = "project name";

	inputs = {
		flake-parts.url = "github:hercules-ci/flake-parts";
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		git-hooks = {
			url = "github:cachix/git-hooks.nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs @ {
		flake-parts,
		nixpkgs,
		git-hooks,
		self,
		...
	}:
		flake-parts.lib.mkFlake {inherit inputs;} {
			imports = [
			];

			systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

			perSystem = {
				# self', inputs': self, inputs for the same system
				config,
				lib,
				pkgs,
				self',
				system,
				...
			}: {
				packages = {
				};

				devShells = {
					dev =
						import ./devex/shell {
							inherit config pkgs;
							inherit (self') checks;
						};

					default = self'.devShells.dev;
				};

				checks = {
					pre-commit-check =
						git-hooks.lib.${system}.run {
							src = ./.;
							hooks = {
								alejandra = {
									enable = true;
								};

								convco = {
									enable = true;
									# TODO: https://github.com/cachix/git-hooks.nix/pull/614
									# settings.configPath = ./devex/.convco; # remove env.CONVCO_CONFIG
								};

								trim-trailing-whitespace.enable = true;
							};
						};
				};

				formatter = pkgs.alejandra;
			};

			flake = {
			};
		};
}
