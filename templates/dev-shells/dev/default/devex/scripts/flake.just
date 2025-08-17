@_list-recipes:
	just --justfile {{source_file()}} --list

[no-cd]
[group: "formatting"]
format:
	nix fmt -- .

[no-cd]
[group: "checks"]
@check:
	nix flake check

[no-cd]
[group: "templates"]
@list-templates:
	nix flake show --json . 2>/tmp/stderr.$$ | jq -r '.templates | to_entries[] | "\(.key)\t\(.value.description)"' | (echo -e "----\t----"; cat) | column --table --separator $'\t' --table-columns 'template,description' || cat /tmp/stderr.$$ >&2

[no-cd]
[group: "dev shells"]
@list-dev-shells:
	nix flake show --json . 2>/tmp/stderr.$$ | jq -r --arg system $(nix eval --raw nixpkgs#system) '.devShells[$system] | to_entries[] | select(.key | startswith("_") | not) | "\(.key)\t\(.value.description)"' | (echo -e "----\t----"; cat) | column --table --separator $'\t' --table-columns 'id,description' || cat /tmp/stderr.$$ >&2

[no-cd]
[group: "packages"]
@list-packages:
	nix flake show --json . 2>/tmp/stderr.$$ | jq -r --arg system $(nix eval --raw nixpkgs#system) '.packages[$system] | to_entries[] | select(.key | startswith("_") | not) | "\(.key)\t\(.value.name)\t\(.value.description)"' | (echo -e "----\t----\t----"; cat) | column --table --separator $'\t' --table-columns package,name,description || cat /tmp/stderr.$$ >&2
