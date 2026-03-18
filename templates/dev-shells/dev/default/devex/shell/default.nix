{
  pkgs,
  self ? ../..,
  self',
  ...
}: let
  devexJust = import (self + /devex/scripts/devex.just.nix) {inherit pkgs;};
  justfile = import (self + /devex/scripts/justfile.nix) {
    inherit devexJust pkgs;
  };
  inherit (self'.checks) pre-commit-check;
in
  pkgs.mkShell {
    inputsFrom = [
      # self'.devShells.other-shell-id
    ];

    buildInputs = pre-commit-check.enabledPackages;

    env = {
      JUST_JUSTFILE = "${justfile}";
    };

    packages = with pkgs; [
      just
    ];

    shellHook = ''
      set -a; source ${./.env}; set +a

      ${pre-commit-check.shellHook}

      echo "loaded dev shell"
    '';

    meta = {
      description = "tools for development";
    };
  }
