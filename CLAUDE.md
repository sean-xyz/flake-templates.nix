# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## what this repo is

A nix flake that provides project templates via `nix flake init [--refresh] -t`. Templates are self-contained starter kits for new repositories, each with a dev shell, pre-commit hooks, justfile recipes, and direnv integration.

## commands

```bash
# build this repo's own dev shell
nix build .#devShells.$(nix eval --raw nixpkgs#stdenv.hostPlatform.system).dev

# check (runs pre-commit hooks including alejandra, deadnix, convco, trim-trailing-whitespace)
nix flake check

# format nix code
nix fmt

# build a specific template's dev shell to verify it evaluates
nix build .#devShells.$(nix eval --raw nixpkgs#stdenv.hostPlatform.system).dev
```

Inside the dev shell (`nix develop`), `just` recipes are available:
- `just devex format` — format nix with alejandra
- `just devex deadnix` — remove unused nix code
- `just devex list-templates` — show available templates
- `just devex list-dev-shells` — show available dev shells
- `just devex build-dev-shell <id>` — build a specific dev shell
- `just pre-commit` — run pre-commit hooks
- `just pre-commit-sandbox` — run checks in nix sandbox (equivalent to `nix flake check`)

## architecture

The root `flake.nix` serves two purposes:
1. **Defines templates** in `flake.templates` — each entry points to a directory under `templates/`
2. **Provides its own dev shell** for working on this repo, importing from `devex/` (symlinked to `templates/dev-shells/dev/default/devex/`)

### template structure

Each template under `templates/dev-shells/dev/<variant>/` is a complete, standalone flake:
- `flake.nix` — flake-parts based, with git-hooks checks (alejandra, convco, deadnix, no-commit-to-branch, trailing whitespace)
- `devex/shell/default.nix` — mkShell definition with packages, env vars, and shell hooks
- `devex/shell/.env` — build-time env vars loaded into the nix derivation (notably `JUST_WORKING_DIRECTORY`)
- `devex/scripts/justfile.nix` — nix expression that generates a justfile (project-specific recipes)
- `devex/scripts/devex.just.nix` — nix expression for the `devex` just submodule (shared devex recipes)
- `devex/.convco` — conventional commit config (host/owner/repository must be filled in by template user)
- `.envrc` — direnv config using `use flake`
- `.env`, `.prettierrc.yaml`, `.prettierignore` — project config files

### justfile generation pattern

Justfiles are not static files — they are nix expressions (`writeText`) that interpolate absolute nix store paths for tools (via `getExe`). This ensures recipes use the exact tool versions from the flake's nixpkgs pin. The main justfile imports `devex.just` as a `mod` submodule.

### adding a new template

1. Create a new directory under `templates/dev-shells/dev/<name>/` (can copy from `default/`)
2. Customize the dev shell packages in `devex/shell/default.nix`
3. Register it in the root `flake.nix` under `flake.templates`
4. The template's devShell name should match its template path segment (e.g. `dev/go` for `templates/dev-shells/dev/go/`)

### root-level symlinks

The root `.env`, `.prettierignore`, `.prettierrc.yaml`, and `devex/` are symlinks into `templates/dev-shells/dev/default/` — the repo dogfoods its own default template for development.

## commit conventions

Conventional commits enforced by convco. Allowed types: `feat`, `fix`, `build`, `chore`, `ci`, `devex`, `docs`, `style`, `refactor`, `perf`, `test`. Only `feat` (minor) and `fix` (patch) bump versions.
