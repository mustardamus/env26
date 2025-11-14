import { join } from "node:path";
import {
  getAllFiles,
  getChangedFiles,
  executeCommand,
  getLanguageConfig,
} from "./shared";

const mode = Bun.argv[2] || "health";

if (!["changed", "all"].includes(mode)) {
  console.error(`Invalid mode: ${mode}`);
  console.error("Usage: bun format.ts [changed|all]");
  process.exit(1);
}

const rootDir = join(import.meta.dirname, "../..");
const ignorePatterns = [
  ".opencode/.gitignore",
  ".opencode/package.json",
  "bun.lock",
  ".gitignore",
];

const files =
  mode === "changed"
    ? await getChangedFiles(rootDir, ignorePatterns)
    : await getAllFiles(rootDir, ignorePatterns);

for (const filePath of files) {
  const ext = filePath.split(".").at(-1) || "";
  let cmd = "";

  if (
    [
      "js",
      "cjs",
      "mjs",
      "jsx",
      "ts",
      "tsx",
      "json",
      "md",
      "yaml",
      "css",
      "html",
    ].includes(ext)
  ) {
    cmd = `bun run prettier -- --write ${filePath}`;
  } else if (ext === "astro") {
    cmd = `bun run prettier -- --write --plugin prettier-plugin-astro ${filePath}`;
  } else if (ext === "sh") {
    cmd = `shfmt -w ${filePath}`;
  } else if (ext === "toml") {
    cmd = `taplo fmt ${filePath}`;
  } else if (ext === "fish") {
    cmd = `fish_indent --write ${filePath}`;
  } else if (ext === "containerfile") {
    cmd = `dockerfmt --write ${filePath}`;
  } else {
    console.warn(`? No formatter for ${filePath}`);
    continue;
  }

  if (cmd) {
    const res = await executeCommand(cmd);

    if (res.success) {
      console.log(`✓ ${cmd}`);
    } else {
      console.error(`✗ ${cmd}`);
      console.error(res.stderr);
    }
  }
}
