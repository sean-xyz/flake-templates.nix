{
  description = "flake templates";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs @ {
    flake-parts,
    git-hooks,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;

      perSystem = {
        config,
        pkgs,
        self',
        system,
        ...
      }: {
        devShells = {
          dev = import ./devex/shell {
            inherit config pkgs self self';
          };

          default = self'.devShells.dev;
        };

        checks = {
          pre-commit-check = git-hooks.lib.${system}.run {
            src = self;
            hooks = {
              alejandra = {
                enable = true;
              };

              convco = {
                enable = true;
                settings.configPath = self + /devex/.convco;
              };

              no-commit-to-branch = {
                enable = true;
                settings.branch = ["main" "master"];
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
            description = "development project";
            welcomeText = ''
              # developer template
              ## usage
              - fill in `host`, `owner`, `repository` in `devex/.convco`
              - edit docs/README.md
              - add just recipes to `devex/scripts/justfile.nix`
              - edit .gitignore
            '';
          };
          "dev-shells/dev/go" = {
            path = ./templates/dev-shells/dev/go;
            description = "go project";
            welcomeText = ''
              # developer template
              ## usage
              - fill in `host`, `owner`, `repository` in `devex/.convco`
              - edit docs/README.md
              - add just recipes to `devex/scripts/justfile.nix`
              - edit .gitignore
            '';
          };
        };
      };
    };
}
