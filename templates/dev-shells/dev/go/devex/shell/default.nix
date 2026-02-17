{
  pkgs,
  self',
  ...
}: let
  flakeJust = import (self + /devex/scripts/flake.just.nix) {inherit pkgs;};
  justfile = import (self + /devex/scripts/justfile.nix) {
    inherit flakeJust pkgs;
  };
  inherit (self'.checks) pre-commit-check;
in
  pkgs.mkShell {
    buildInputs = pre-commit-check.enabledPackages;

    env = {
      JUST_JUSTFILE = "${justfile}";
    };

    packages = with pkgs; [
      delve
      go
      golangci-lint
      just
    ];

    shellHook = ''
      set -a; source ${./.env}; set +a

      ${pre-commit-check.shellHook}

      echo "loaded dev/go shell"
    '';

    meta = {
      description = "tools for go development";
    };
  }
