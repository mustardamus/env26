# env26

## Requirements

- [Podman](https://podman.io/) with [rootless mode][rootless] - Container
  engine

[rootless]: https://docs.podman.io/en/latest/markdown/podman.1.html#rootless-mode

- [Make](https://www.gnu.org/software/make/) - Build automation tool

## Quick Start

Run `make` to start the development environment. See
[Makefile](#makefile-tasks) for all available commands.

## Development Environment

### Container

Running in a [Debian Trixie](https://hub.docker.com/_/debian) container
([dev.containerfile](env/dev/dev.containerfile))

### Base System

Base packages installed via apt:

- [build-essential](https://packages.debian.org/trixie/build-essential) -
  Essential build tools
- [ca-certificates](https://packages.debian.org/trixie/ca-certificates) -
  Common CA certificates
- [sudo](https://packages.debian.org/trixie/sudo) - Privilege escalation tool
- [curl](https://packages.debian.org/trixie/curl) - Command line HTTP client
- [git](https://packages.debian.org/trixie/git) - Version control system
- [gnupg2](https://packages.debian.org/trixie/gnupg2) - GNU privacy guard
- [zip](https://packages.debian.org/trixie/zip) /
  [unzip](https://packages.debian.org/trixie/unzip) - Archive utilities
- [fish](https://packages.debian.org/trixie/fish) - Friendly interactive shell
- [tzdata](https://packages.debian.org/trixie/tzdata) - Timezone data (Europe/Berlin)
- [chromium](https://packages.debian.org/trixie/chromium) - Web browser

User `dev` with passwordless sudo access

### Shell

[Fish](https://fishshell.com/) ([config](env/dev/fish/config.fish)) with
plugins managed by [Fisher](https://github.com/jorgebucaran/fisher):

- [hydro](https://github.com/jorgebucaran/hydro) - Minimal, lag-free prompt
- [pisces](https://github.com/laughedelic/pisces) - Auto-pairing brackets
  and quotes

### Package Manager

[mise](https://mise.jdx.dev/) - Polyglot runtime manager for managing
development tools

### Terminal Multiplexer

[Zellij](https://zellij.dev/) ([config](env/dev/zellij/config.kdl))

- Tokyo Night Dark theme ([theme file](env/dev/zellij/themes/tokyo-night-dark.kdl))
- Custom keybindings with F1-F12 for tab navigation
- Default layout ([layout file](env/dev/zellij/layouts/default.kdl))

### Editor

[Helix](https://helix-editor.com/) ([config](env/dev/helix/config.toml))

### Supported Languages

All languages supported by the development environment with their tools:

| Language                                                              | LSP                                                                                                                                                  | Linter                                                                                                                                                                                   | Formatter                                                                                                      |
| --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| [TypeScript](https://www.typescriptlang.org/)                         | [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)                                               | [ESLint](https://eslint.org/) ([@typescript-eslint](https://typescript-eslint.io/)) + [tsc](https://www.typescriptlang.org/docs/handbook/compiler-options.html)                          | [Prettier](https://prettier.io/)                                                                               |
| [JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript) | [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)                                               | [ESLint](https://eslint.org/)                                                                                                                                                            | [Prettier](https://prettier.io/)                                                                               |
| [Astro](https://astro.build/)                                         | [@astrojs/language-server](https://github.com/withastro/language-tools) + [tailwindcss-ls](https://github.com/tailwindlabs/tailwindcss-intellisense) | [ESLint](https://eslint.org/) ([eslint-plugin-astro](https://github.com/ota-meshi/eslint-plugin-astro) + [eslint-plugin-jsx-a11y](https://github.com/jsx-eslint/eslint-plugin-jsx-a11y)) | [Prettier](https://prettier.io/) + [prettier-plugin-astro](https://github.com/withastro/prettier-plugin-astro) |
| [JSON](https://www.json.org/)                                         | [vscode-json-language-server](https://github.com/microsoft/vscode-languageserver-node)                                                               | [ESLint](https://eslint.org/) ([eslint-plugin-jsonc](https://github.com/ota-meshi/eslint-plugin-jsonc))                                                                                  | [Prettier](https://prettier.io/)                                                                               |
| [Markdown](https://www.markdownguide.org/)                            | [vscode-markdown-language-server](https://github.com/microsoft/vscode)                                                                               | [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2)                                                                                                                     | [Prettier](https://prettier.io/)                                                                               |
| [YAML](https://yaml.org/)                                             | [yaml-language-server](https://github.com/redhat-developer/yaml-language-server)                                                                     | [yq](https://github.com/mikefarah/yq)                                                                                                                                                    | [Prettier](https://prettier.io/)                                                                               |
| [TOML](https://toml.io/)                                              | [taplo](https://taplo.tamasfe.dev/)                                                                                                                  | [taplo check](https://taplo.tamasfe.dev/)                                                                                                                                                | [taplo fmt](https://taplo.tamasfe.dev/)                                                                        |
| [CSS](https://www.w3.org/Style/CSS/)                                  | [vscode-css-language-server](https://github.com/microsoft/vscode-languageserver-node)                                                                | [Stylelint](https://stylelint.io/)                                                                                                                                                       | [Prettier](https://prettier.io/)                                                                               |
| [HTML](https://html.spec.whatwg.org/)                                 | [vscode-html-language-server](https://github.com/microsoft/vscode-languageserver-node)                                                               | [html-validate](https://html-validate.org/)                                                                                                                                              | [Prettier](https://prettier.io/)                                                                               |
| [Bash](https://www.gnu.org/software/bash/)                            | [bash-language-server](https://github.com/bash-lsp/bash-language-server)                                                                             | [shellcheck](https://www.shellcheck.net/)                                                                                                                                                | [shfmt](https://github.com/mvdan/sh)                                                                           |
| [Fish](https://fishshell.com/)                                        | -                                                                                                                                                    | -                                                                                                                                                                                        | [fish_indent](https://fishshell.com/docs/current/cmds/fish_indent.html)                                        |
| [Dockerfile](https://docs.docker.com/reference/dockerfile/)           | [dockerfile-language-server](https://github.com/rcjsuen/dockerfile-language-server-nodejs)                                                           | -                                                                                                                                                                                        | [dockerfmt](https://github.com/reteps/dockerfmt)                                                               |
| [Caddyfile](https://caddyserver.com/docs/caddyfile)                   | -                                                                                                                                                    | [caddy validate](https://caddyserver.com/docs/command-line#caddy-validate)                                                                                                               | -                                                                                                              |
| [KDL](https://kdl.dev/)                                               | -                                                                                                                                                    | -                                                                                                                                                                                        | -                                                                                                              |

**Note**: All languages also have
[simple-completion-language-server](https://github.com/estin/simple-completion-language-server)
enabled for additional completions and snippets.

### Code Snippets

Custom snippets ([snippets directory](env/dev/snippets/)):

- [Astro](env/dev/snippets/astro.toml)
- [JavaScript](env/dev/snippets/javascript.toml)
- [TypeScript](env/dev/snippets/typescript.toml)

### Formatting

[format.ts](env/dev/format.ts) - Automated code formatting script

Intelligently formats files according to the Helix configuration using the
appropriate formatter for each file type.

- **Smart file detection**: Automatically detects file types and applies the
  correct formatter
- **Git integration**: Formats only changed/uncommitted files by default
- **Gitignore aware**: Dynamically reads `.gitignore` to exclude files and
  directories
- **Error handling**: Safely handles formatter failures with automatic cleanup
  of temporary files
- **Colored output**: Clear visual feedback during formatting

```bash
make format           # Format changed and uncommitted files
make format_all       # Format all files in the project
```

### Linting

[lint.ts](env/dev/lint.ts) - Automated code linting script

Checks files for errors and code quality issues using appropriate linters
for each file type.

- **TypeScript type checking**: Runs `tsc --noEmit` for full type safety
  validation
- **Smart file detection**: Automatically detects file types and applies the
  correct linter
- **Git integration**: Lints only changed/uncommitted files by default
- **Gitignore aware**: Dynamically reads `.gitignore` to exclude files and
  directories
- **Exit codes**: Returns non-zero exit code if lint errors are found
- **Colored output**: Clear visual feedback with error counts

```bash
make lint             # Lint changed and uncommitted files
make lint_all         # Lint all files in the project
```

### Linter Plugin Management

Linter plugins (ESLint, Stylelint) are installed globally via mise and symlinked
into the project's `node_modules/` directory. This approach:

- Uses global installations managed by mise
- Avoids polluting `package.json` with linter dependencies
- Automatically creates symlinks on container startup

Symlinks are created automatically by
[setup-symlinks.sh](env/dev/setup-symlinks.sh) when running `make` (dev
environment startup). The script creates symlinks for:

- `@typescript-eslint/parser` & `@typescript-eslint/eslint-plugin`
- `eslint-plugin-astro`
- `eslint-plugin-jsonc`
- `eslint-plugin-jsx-a11y`
- `stylelint`

To manually recreate symlinks (if needed):

```bash
bash env/dev/setup-symlinks.sh
```

### AI Assistant

[OpenCode](https://opencode.ai/) with MCP servers:

- [chrome-devtools-mcp](https://github.com/sst/chrome-devtools-mcp) - Chrome
  DevTools integration

### Runtime & Tooling

- [Bun](https://bun.sh/) - Fast all-in-one JavaScript runtime and package manager
- [Node.js](https://nodejs.org/) LTS - JavaScript runtime (still used for
  compatibility)

### Development Tools

- [ripgrep](https://github.com/BurntSushi/ripgrep) - Fast recursive grep
- [fd](https://github.com/sharkdp/fd) - Fast find alternative
- [jq](https://jqlang.github.io/jq/) - JSON processor
- [yq](https://github.com/mikefarah/yq) - YAML processor
- [LazyGit](https://github.com/jesseduffield/lazygit) - Terminal UI for git

### Testing & Email

[MailHog](https://github.com/mailhog/MailHog) - Email testing tool for developers

### Reverse Proxy

[Caddy](https://caddyserver.com/) ([Caddyfile](env/dev/Caddyfile)) - Modern
web server with automatic HTTPS

### Backend

[PocketBase](https://pocketbase.io/) - Open-source backend with real-time
database and authentication

### Makefile Tasks

| Command           | Description                             |
| ----------------- | --------------------------------------- |
| `make`            | Start development environment (default) |
| `make dev_build`  | Build development container image       |
| `make dev_reset`  | Delete containers, images, and volumes  |
| `make format`     | Format changed and uncommitted files    |
| `make format_all` | Format all files in the project         |
| `make lint`       | Lint changed and uncommitted files      |
| `make lint_all`   | Lint all files in the project           |
| `make help`       | Show all available commands             |

## Application Stack

### Frontend Framework

[Astro](https://astro.build/) - Modern web framework for content-driven websites

### Styling

- [Tailwind CSS](https://tailwindcss.com/) - Utility-first CSS framework
- [@tailwindcss/vite](https://www.npmjs.com/package/@tailwindcss/vite) - Vite
  plugin for Tailwind CSS

### Language

[TypeScript](https://www.typescriptlang.org/) - Type-safe JavaScript with
strict configuration

### Available Scripts

- `bun run dev` - Start development server
- `bun run build` - Build for production
- `bun run preview` - Preview production build
- `bun run astro` - Run Astro CLI commands

## Project Structure

```text
├── env/                    # Development environment configuration
│   └── dev/               # Dev container setup
│       ├── fish/          # Fish shell config
│       ├── helix/         # Helix editor config
│       ├── snippets/      # Code snippets
│       ├── zellij/        # Terminal multiplexer config
│       ├── Caddyfile      # Caddy server config
│       ├── dev.containerfile  # Container definition
│       └── run.sh         # Container orchestration script
├── public/                # Static assets
├── src/
│   ├── assets/           # Project assets (CSS, images)
│   ├── components/       # Astro components
│   ├── layouts/          # Page layouts
│   └── pages/            # Route pages
├── astro.config.mjs      # Astro configuration
├── bunfig.toml           # Bun configuration
├── Makefile              # Build automation
├── package.json          # Dependencies and scripts
└── tsconfig.json         # TypeScript configuration
```
