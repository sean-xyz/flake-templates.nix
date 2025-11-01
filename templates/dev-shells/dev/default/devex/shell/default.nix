{
  config,
  pkgs,
  self ? ../..,
  self',
  ...
}:
pkgs.mkShell {
  inputsFrom = [
    # self'.devShells.other-shell-id
  ];

  env = {
    JUST_JUSTFILE = "${self + /devex/scripts/justfile}";
  };

  packages = with pkgs; [
    self'.checks.pre-commit-check.enabledPackages
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
