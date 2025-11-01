{
  config,
  pkgs,
  self ? ../..,
  self',
  ...
}:
pkgs.mkShell {
  packages = with pkgs; [
    self'.checks.pre-commit-check.enabledPackages
    delve
    go
    golangci-lint
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
    description = "tools for go development";
  };
}
