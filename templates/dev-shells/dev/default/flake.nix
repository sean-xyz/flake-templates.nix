{
  description = "project name";

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
      imports = [
      ];

      systems = import inputs.systems;

      perSystem = {
        config,
        pkgs,
        self',
        system,
        ...
      }: {
        packages = {
        };

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

              deadnix = {
                enable = true;
                settings.noUnderscore = true;
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
      };
    };
}
