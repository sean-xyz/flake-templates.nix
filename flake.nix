{
	description = "flake templates";

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
			systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

			perSystem = {
				config,
				pkgs,
				self',
				system,
				...
			}: {
				devShells = {
					dev =
						import ./devex/shell {
							inherit config pkgs;
							inherit (self') checks;
							flakeRoot = ./templates/dev-shells/dev/default;
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
								};

								trim-trailing-whitespace.enable = true;
							};
						};
				};

				formatter = pkgs.alejandra;
			};

			flake = {
				templates = {
					"dev-shells/dev" = {
						path = ./templates/dev-shells/dev/default;
						description = "general dev environment";
					};
				};
			};
		};
}
