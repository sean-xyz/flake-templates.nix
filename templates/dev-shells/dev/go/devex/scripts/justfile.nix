{
  pkgs,
  devexJust,
}: let
  inherit (pkgs.lib) getExe;
  just = getExe pkgs.just;
  nix = getExe pkgs.nix;
  prettier = getExe pkgs.nodePackages.prettier;
in
  pkgs.writeText "justfile" ''
    set quiet := false

    [doc: "recipes for the nix flake devex environment"]
    [group: "submodules"]
    mod devex "${devexJust}"

    @_list-recipes:
    	${just} --list

    [doc: "format code"]
    [group: "formatting"]
    format:
    	${prettier} --write .

    [doc: "check code formatting"]
    [group: "formatting"]
    format-check:
    	${prettier} --check .

    [doc: "run pre-commit checks"]
    [group: "git checks"]
    pre-commit:
    	${nix} develop -c pre-commit run -a

    [doc: "run pre-commit checks (read-only filesystem, no internet access, no git branch information)"]
    [group: "git checks"]
    pre-commit-sandbox:
    	${nix} flake check
  ''
