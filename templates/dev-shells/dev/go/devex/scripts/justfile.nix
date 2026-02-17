{
  pkgs,
  flakeJust,
}: let
  inherit (pkgs.lib) getExe;
  just = getExe pkgs.just;
  prettier = getExe pkgs.nodePackages.prettier;
in
  pkgs.writeText "justfile" ''
    set quiet := false

    [group: "submodules"]
    mod flake "${flakeJust}"

    @_list-recipes:
    	${just} --list

    [group: "formatting"]
    format:
    	${prettier} --write .
  ''
