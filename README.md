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

| Language   | LSP                                                                                        |
| ---------- | ------------------------------------------------------------------------------------------ |
| All        | [simple-completion-language-server](https://github.com/estin/simple-completion-language-server) |
| TOML       | [taplo](https://taplo.tamasfe.dev/) |
| Bash       | [bash-language-server](https://github.com/bash-lsp/bash-language-server) |
| Markdown   | [vscode-markdown-language-server](https://github.com/microsoft/vscode) |
| Dockerfile | [dockerfile-language-server](https://github.com/rcjsuen/dockerfile-language-server-nodejs) |
| JSON       | [vscode-json-language-server](https://github.com/microsoft/vscode-languageserver-node) |
| HTML       | [vscode-html-language-server](https://github.com/microsoft/vscode-languageserver-node) |
| CSS        | [vscode-css-language-server](https://github.com/microsoft/vscode-languageserver-node) |
| TypeScript | [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server) |
| JavaScript | [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server) |

#### Formatters

[helix/languages.toml](env/dev/helix/languages.toml)

| Language   | Formatter                                        |
| ---------- | ------------------------------------------------ |
| TOML       | [taplo](https://taplo.tamasfe.dev/)              |
| Bash       | [shfmt](https://github.com/mvdan/sh)             |
| Markdown   | [prettier](https://prettier.io/)                 |
| Dockerfile | [dockerfmt](https://github.com/reteps/dockerfmt) |
| JSON       | [prettier](https://prettier.io/)                 |
| HTML       | [prettier](https://prettier.io/)                 |
| CSS        | [prettier](https://prettier.io/)                 |
| TypeScript | [prettier](https://prettier.io/)                 |
| JavaScript | [prettier](https://prettier.io/)                 |
