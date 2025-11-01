# env26

## Get Started

`make` - Starts the dev environment
`make dev_build` - Builds the dev ímage
`make dev_reset` - Stops containers, remove images, remove volumes

## Development Environment

### Debian

- base packages
- timezone set
- user `dev`
- passwordless sudo

### Shell

- fish with plugins

### Package Manager

- mise

### Editor with LSPs

- helix

#### Language Servers

[helix/languages.toml](env/dev/helix/languages.toml)

| Language | LSP                                                                      |
| -------- | ------------------------------------------------------------------------ |
| TOML     | [taplo](https://taplo.tamasfe.dev/)                                      |
| Bash     | [bash-language-server](https://github.com/bash-lsp/bash-language-server) |
