export interface LanguageConfig {
  lang: string;
  ext: string[];
  format?: string;
  lint?: string;
}

const languageConfigs: LanguageConfig[] = [
  {
    lang: "typescript",
    ext: [".ts", ".tsx"],
    format: "prettier --write $1",
    lint: "~/.local/share/mise/installs/npm-eslint/latest/bin/eslint $1 && tsc --noEmit --skipLibCheck --module esnext --target esnext --lib esnext,dom --moduleResolution bundler --downlevelIteration $1",
  },
  {
    lang: "javascript",
    ext: [".js", ".jsx", ".mjs", ".cjs"],
    format: "prettier --write $1",
    lint: "~/.local/share/mise/installs/npm-eslint/latest/bin/eslint $1",
  },
  {
    lang: "astro",
    ext: [".astro"],
    format:
      "prettier --write --plugin ~/.local/share/mise/installs/npm-prettier-plugin-astro/latest/lib/node_modules/prettier-plugin-astro/dist/index.js $1",
    lint: "~/.local/share/mise/installs/npm-eslint/latest/bin/eslint $1",
  },
  {
    lang: "json",
    ext: [".json"],
    format: "prettier --write $1",
    lint: "~/.local/share/mise/installs/npm-eslint/latest/bin/eslint $1",
  },
  {
    lang: "markdown",
    ext: [".md"],
    format: "prettier --write $1",
    lint: "markdownlint-cli2 $1",
  },
  {
    lang: "yaml",
    ext: [".yaml", ".yml"],
    format: "prettier --write $1",
    lint: "yq eval $1",
  },
  {
    lang: "toml",
    ext: [".toml"],
    format: "taplo fmt $1",
    lint: "taplo check $1",
  },
  {
    lang: "css",
    ext: [".css"],
    format: "prettier --write $1",
    lint: "~/.local/share/mise/installs/npm-stylelint/latest/bin/stylelint $1",
  },
  {
    lang: "html",
    ext: [".html"],
    format: "prettier --write $1",
    lint: "~/.local/share/mise/installs/npm-html-validate/latest/bin/html-validate $1",
  },
  {
    lang: "bash",
    ext: [".sh", ".bash"],
    format: "shfmt -w $1",
    lint: "shellcheck $1",
  },
  {
    lang: "fish",
    ext: [".fish"],
    format: "fish_indent --write $1",
  },
  {
    lang: "dockerfile",
    ext: [".dockerfile", ".containerfile"],
    format: "dockerfmt --write $1",
  },
  {
    lang: "caddyfile",
    ext: ["Caddyfile"],
    lint: "caddy validate --config $1",
  },
  {
    lang: "kdl",
    ext: [".kdl"],
    // No formatter available
  },
];

export default languageConfigs;
