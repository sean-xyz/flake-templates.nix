{
  config,
  pkgs,
  self ? ../..,
  self',
  ...
}:
pkgs.mkShell {
  buildInputs = self'.checks.pre-commit-check.enabledPackages;

  inputsFrom = [
    # self'.devShells.other-shell-id
  ];

  env = {
    CONVCO_CONFIG = "${self + /devex/.convco}";
    JUST_JUSTFILE = "${self + /devex/scripts/justfile}";
  };

  packages = with pkgs; [
    just
    jq
    nodePackages.prettier
    unixtools.column
  ];

  shellHook = ''
    set -a; source ${./.env}; set +a

    ${self'.checks.pre-commit-check.shellHook}

    echo "loaded dev shell"
  '';

  meta = {
    description = "tools for development";
  };
}
