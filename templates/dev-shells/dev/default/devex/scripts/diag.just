set quiet := false

@_list-recipes:
	just --justfile {{source_file()}} --list

[group: "dirs.just"]
@just-invocation-dir:
	echo {{invocation_dir()}}

[group: "dirs.just"]
@just-working-dir:
	{{ if env("JUST_WORKING_DIRECTORY", "") == "" { "echo PWD: " + env("PWD") } else { "echo JUST_WORKING_DIRECTORY: " + env("JUST_WORKING_DIRECTORY") } }}

[group: "dirs.just"]
@just-source-dir:
	echo {{source_directory()}}

[group: "dirs.direnv"]
@direnv-dir:
	echo "DIRENV_DIR: ${DIRENV_DIR}"
