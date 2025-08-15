{
	checks,
	config,
	pkgs,
	flakeRoot ? ../..,
	...
}: let
	# get justfiles with their hierarchy intact so relative imports and submodules still work while in a dev shell
	# e.g. a justfile with `import ../utils.just` and `mod foo` will still have `../utils.just` and `./mod.just` available
	justfiles =
		builtins.filterSource
		(path: type: type == "directory" || !builtins.isNull (builtins.match "^(.+\.just|\.?justfile)$" (baseNameOf path)))
		flakeRoot;
in
	pkgs.mkShell {
		buildInputs = checks.pre-commit-check.enabledPackages;

		inputsFrom = [
			# config.devShells.other-shell-id
		];

		env = {
			CONVCO_CONFIG = "${flakeRoot + /devex/.convco}";
			JUST_JUSTFILE = "${justfiles}/devex/scripts/justfile";
		};

		packages = with pkgs; [
			just
			jq
			nodePackages.prettier
			unixtools.column
		];

		shellHook = ''
			set -a; source ${./.env}; set +a

			${checks.pre-commit-check.shellHook}

			echo "loaded dev shell"
		'';

		meta = {
			description = "tools for development";
		};
	}
