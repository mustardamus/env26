#!/usr/bin/env bash
# Setup symlinks for globally installed linter plugins

set -e

APP_DIR="${1:-/home/dev/app}"
NODE_MODULES="$APP_DIR/node_modules"
MISE_INSTALLS="$HOME/.local/share/mise/installs"

# Create node_modules directory if it doesn't exist
mkdir -p "$NODE_MODULES/@typescript-eslint"

# ESLint TypeScript plugins
if [ -d "$MISE_INSTALLS/npm-typescript-eslint-parser/latest/lib/node_modules/@typescript-eslint/parser" ]; then
	ln -sf "$MISE_INSTALLS/npm-typescript-eslint-parser/latest/lib/node_modules/@typescript-eslint/parser" \
		"$NODE_MODULES/@typescript-eslint/parser"
fi

if [ -d "$MISE_INSTALLS/npm-typescript-eslint-eslint-plugin/latest/lib/node_modules/@typescript-eslint/eslint-plugin" ]; then
	ln -sf "$MISE_INSTALLS/npm-typescript-eslint-eslint-plugin/latest/lib/node_modules/@typescript-eslint/eslint-plugin" \
		"$NODE_MODULES/@typescript-eslint/eslint-plugin"
fi

# ESLint Astro plugin
if [ -d "$MISE_INSTALLS/npm-eslint-plugin-astro/latest/lib/node_modules/eslint-plugin-astro" ]; then
	ln -sf "$MISE_INSTALLS/npm-eslint-plugin-astro/latest/lib/node_modules/eslint-plugin-astro" \
		"$NODE_MODULES/eslint-plugin-astro"
fi

# ESLint JSON plugin
if [ -d "$MISE_INSTALLS/npm-eslint-plugin-jsonc/latest/lib/node_modules/eslint-plugin-jsonc" ]; then
	ln -sf "$MISE_INSTALLS/npm-eslint-plugin-jsonc/latest/lib/node_modules/eslint-plugin-jsonc" \
		"$NODE_MODULES/eslint-plugin-jsonc"
fi

# Stylelint
if [ -d "$MISE_INSTALLS/npm-stylelint/latest/lib/node_modules/stylelint" ]; then
	ln -sf "$MISE_INSTALLS/npm-stylelint/latest/lib/node_modules/stylelint" \
		"$NODE_MODULES/stylelint"
fi
