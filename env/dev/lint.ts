import { join } from "node:path";
import {
  getAllFiles,
  getChangedFiles,
  executeCommand,
  binaryExists,
  getLanguageConfig,
} from "./shared";

const mode = Bun.argv[2] || "health";

if (!["health", "changed", "all"].includes(mode)) {
  console.error(`Invalid mode: ${mode}`);
  console.error("Usage: bun run lint.ts [health|changed|all]");
  process.exit(1);
}

const rootDir = join(import.meta.dirname, "../..");
const ignorePatterns = [".opencode", "bun.lock", ".gitignore"];

const files =
  mode === "changed"
    ? await getChangedFiles(rootDir, ignorePatterns)
    : await getAllFiles(rootDir, ignorePatterns);

for (const file of files) {
  const config = getLanguageConfig(file);

  if (!config) {
    if (mode === "health") {
      console.warn("✗ NO CONFIG FOUND FOR", file);
    }
    continue;
  }

  if (config.lint) {
    const binary = config.lint.split(" ").at(0) || "";
    const exists = await binaryExists(binary);

    if (!exists) {
      if (mode === "health") {
        console.warn(
          `[${config.lang}] Binary '${binary}' not found for lint command`,
        );
      }
    } else {
      if (mode !== "health") {
        const lintCmd = config.lint.replace(/\$1/g, file);
        const result = await executeCommand(lintCmd);
        const icon = result.success ? "✓" : "✗";

        console.log(`${icon} [${config.lang}](lint): ${lintCmd}`);

        if (!result.success) {
          if (result.stdout) {
            console.error(result.stdout);
          }

          if (result.stderr) {
            console.error(result.stderr);
          }
        }
      }
    }
  } else {
    if (mode === "health") {
      console.warn("✗ NO LINTER DEFINED FOR", file);
    }
  }

  console.log("\n");
}
