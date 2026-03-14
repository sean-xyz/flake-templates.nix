# flake templates

## usage

### list templates

```bash
nix flake show --json github:sean-xyz/flake-templates.nix 2>/dev/null | jq -r '.templates'
```

### dev shells

```bash
nix flake init -t github:sean-xyz/flake-templates.nix#dev-shells/dev
```
