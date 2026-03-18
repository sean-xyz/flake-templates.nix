# flake templates

## usage

### list templates

```bash
nix flake show --json github:sean-xyz/flake-templates.nix 2>/dev/null | jq -r '.templates'
```

### dev shells


```bash
dev_shell="dev"
nix flake init --refresh -t github:sean-xyz/flake-templates.nix#dev-shells/${dev_shell}
```
