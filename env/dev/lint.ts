import { join } from "node:path";
import { getAllFiles, getChangedFiles, executeCommand } from "./shared";

const mode = Bun.argv[2] || "";

if (!["changed", "all"].includes(mode)) {
  console.error(`Invalid mode: ${mode}`);
  console.error("Usage: bun lint.ts [changed|all]");
  process.exit(1);
}

const rootDir = join(import.meta.dirname, "../..");
const ignorePatterns = [
  ".opencode",
  "bun.lock",
  ".gitignore",
  "*.svg",
  "*.kdl",
];
const files =
  mode === "changed"
    ? await getChangedFiles(rootDir, ignorePatterns)
    : await getAllFiles(rootDir, ignorePatterns);
const commands = [];

for (const filePath of files) {
  let ext = filePath.split(".").at(-1) || "";

  if (ext === filePath) {
    ext = filePath.split("/").at(-1) || "";
  }

  if (
    [
      "js",
      "cjs",
      "mjs",
      "jsx",
      "ts",
      "tsx",
      "json",
      "yml",
      "yaml",
      "astro",
    ].includes(ext)
  ) {
    commands.push(`bunx eslint --fix ${filePath}`);
  } else if (ext === "css") {
    commands.push(`bunx stylelint --fix ${filePath}`);
  } else if (ext === "html") {
    commands.push(`bunx html-validate ${filePath}`);
  } else if (ext === "md") {
    commands.push(`bunx markdownlint-cli2 --fix ${filePath}`);
  } else if (ext === "sh") {
    commands.push(`shellcheck ${filePath}`);
  } else if (ext === "fish") {
    commands.push(`fish --no-execute ${filePath}`);
  } else if (ext === "toml") {
    commands.push(`taplo lint ${filePath}`);
  } else if (ext === "Caddyfile") {
    commands.push(`caddy validate --config ${filePath}`);
  } else if (ext === "Makefile") {
    commands.push(`checkmake ${filePath}`);
  } else if (
    ["containerfile", "dockerfile", "Containerfile", "Dockerfile"].includes(ext)
  ) {
    commands.push(`hadolint ${filePath}`);
  } else {
    console.warn(`? No linter for ${filePath}`);
    continue;
  }
}

// `astro check` dont work on specific files, just project wide
if (files.find((p) => p.endsWith(".astro"))) {
  commands.push("bunx astro check");
}

for (const cmd of commands) {
  const res = await executeCommand(cmd);

  if (res.success) {
    console.log(`✓ ${cmd}`);
    console.log(res.stdout);
  } else {
    console.error(`✗ ${cmd}`);
    console.error(res.stderr);
    console.error(res.stdout);
  }
}
