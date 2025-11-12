export interface LanguageConfig {
  lang: string;
  ext: string[];
  formatScript?: string; // npm script name
  lintScript?: string; // npm script name
}

const languageConfigs: LanguageConfig[] = [
  {
    lang: "typescript",
    ext: [".ts", ".tsx"],
    formatScript: "format:ts",
    lintScript: "lint:ts",
  },
  {
    lang: "javascript",
    ext: [".js", ".jsx", ".mjs", ".cjs"],
    formatScript: "format:js",
    lintScript: "lint:js",
  },
  {
    lang: "astro",
    ext: [".astro"],
    formatScript: "format:astro",
    lintScript: "lint:astro",
  },
  {
    lang: "json",
    ext: [".json"],
    formatScript: "format:json",
    lintScript: "lint:json",
  },
  {
    lang: "markdown",
    ext: [".md"],
    formatScript: "format:md",
    lintScript: "lint:md",
  },
  {
    lang: "yaml",
    ext: [".yaml", ".yml"],
    formatScript: "format:yaml",
    lintScript: "lint:yaml",
  },
  {
    lang: "toml",
    ext: [".toml"],
    formatScript: "format:toml",
    lintScript: "lint:toml",
  },
  {
    lang: "css",
    ext: [".css"],
    formatScript: "format:css",
    lintScript: "lint:css",
  },
  {
    lang: "html",
    ext: [".html"],
    formatScript: "format:html",
    lintScript: "lint:html",
  },
  {
    lang: "bash",
    ext: [".sh", ".bash"],
    formatScript: "format:bash",
    lintScript: "lint:bash",
  },
  {
    lang: "fish",
    ext: [".fish"],
    formatScript: "format:fish",
  },
  {
    lang: "dockerfile",
    ext: [".dockerfile", ".containerfile"],
    formatScript: "format:dockerfile",
  },
  {
    lang: "caddyfile",
    ext: ["Caddyfile"],
    lintScript: "lint:caddyfile",
  },
  {
    lang: "kdl",
    ext: [".kdl"],
    // No formatter available
  },
];

export default languageConfigs;
