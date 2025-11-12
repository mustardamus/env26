import { join } from "node:path";
import {
  getAllFiles,
  getChangedFiles,
  executeCommand,
  getLanguageConfig,
} from "./shared";

const mode = Bun.argv[2] || "health";

if (!["health", "changed", "all"].includes(mode)) {
  console.error(`Invalid mode: ${mode}`);
  console.error("Usage: bun run lint.ts [health|changed|all]");
  process.exit(1);
}

const rootDir = join(import.meta.dirname, "../..");
const ignorePatterns = [".opencode", "bun.lock", ".gitignore", "node_modules/"];

const files =
  mode === "changed"
    ? await getChangedFiles(rootDir, ignorePatterns)
    : await getAllFiles(rootDir, ignorePatterns);

// Group files by lint script
const filesByScript = new Map<string, string[]>();

for (const file of files) {
  const config = getLanguageConfig(file);

  if (!config) {
    if (mode === "health") {
      console.warn("✗ NO CONFIG FOUND FOR", file);
    }
    continue;
  }

  if (!config.lintScript) {
    if (mode === "health") {
      console.warn(`✗ NO LINTER DEFINED FOR [${config.lang}]`, file);
    }
    continue;
  }

  const existing = filesByScript.get(config.lintScript) || [];
  existing.push(file);
  filesByScript.set(config.lintScript, existing);
}

if (mode === "health") {
  console.log("✓ All lintable files have linters configured");
  process.exit(0);
}

// Run lint commands batched by script
for (const [script, scriptFiles] of filesByScript.entries()) {
  const cmd = `bun run ${script} ${scriptFiles.join(" ")}`;
  const result = await executeCommand(cmd);
  const icon = result.success ? "✓" : "✗";

  console.log(`${icon} [${script}]: ${scriptFiles.length} files`);

  if (!result.success) {
    if (result.stdout) {
      console.error(result.stdout);
    }
    if (result.stderr) {
      console.error(result.stderr);
    }
  }
}
