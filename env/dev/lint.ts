import { join } from "node:path";
import { getAllFiles, getChangedFiles, executeCommand } from "./shared";

const mode = Bun.argv[2] || "";

if (!["changed", "all"].includes(mode)) {
  console.error(`Invalid mode: ${mode}`);
  console.error("Usage: bun format.ts [changed|all]");
  process.exit(1);
}

const rootDir = join(import.meta.dirname, "../..");
const ignorePatterns = [".opencode", "bun.lock", ".gitignore"];
const files =
  mode === "changed"
    ? await getChangedFiles(rootDir, ignorePatterns)
    : await getAllFiles(rootDir, ignorePatterns);

for (const filePath of files) {
  const ext = filePath.split(".").at(-1) || "";
  let cmd = "";

  if (
    ["js", "cjs", "mjs", "jsx", "ts", "tsx", "json", "yml", "yaml"].includes(
      ext,
    )
  ) {
    cmd = `bunx eslint --fix ${filePath}`;
  } else if (ext === "astro") {
    cmd = `bunx eslint --fix ${filePath} && bunx astro check ${filePath}`;
  } else if (ext === "css") {
    cmd = `bunx stylelint --fix ${filePath}`;
  } else if (ext === "html") {
    cmd = `bunx html-validate ${filePath}`;
  } else if (ext === "md") {
    cmd = `bunx markdownlint-cli2 --fix ${filePath}`;
  } else if (ext === "sh") {
    cmd = `shellcheck ${filePath}`;
  } else if (ext === "toml") {
    cmd = `taplo lint ${filePath}`;
  } else if (ext === "Caddyfile") {
    cmd = `caddy validate --config ${filePath}`;
  } else {
    console.warn(`? No linter for ${filePath}`);
    continue;
  }

  if (cmd) {
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
}
