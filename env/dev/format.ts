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
  console.error("Usage: bun run format.ts [health|changed|all]");
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

for (const file of files) {
  const config = getLanguageConfig(file);

  if (!config) {
    if (mode === "health") {
      console.warn("✗ NO CONFIG FOUND FOR", file);
    }
    continue;
  }

  if (config.format) {
    const binary = config.format.split(" ").at(0) || "";
    const exists = await binaryExists(binary);

    if (!exists) {
      if (mode === "health") {
        console.warn(
          `[${config.lang}] Binary '${binary}' not found for format command`,
        );
      }
    } else {
      if (mode !== "health") {
        const formatCmd = config.format.replace(/\$1/g, file);
        const result = await executeCommand(formatCmd);
        const icon = result.success ? "✓" : "✗";

        console.log(`${icon} [${config.lang}](format): ${formatCmd}`);

        if (!result.success && result.stderr) {
          console.error(result.stderr);
        }
      }
    }
  } else {
    if (mode === "health") {
      console.warn("✗ NO FORMATTER DEFINED FOR", file);
    }
  }

  // if (config.lint) {
  //   const binary = config.lint.split(" ").at(0) || "";
  //   const exists = await binaryExists(binary);

  //   if (!exists) {
  //     if (mode === "health") {
  //       console.warn(
  //         `[${config.lang}] Binary '${binary}' not found for lint command`,
  //       );
  //     }
  //   } else {
  //     const lintCmd = config.lint.replace(/\$1/g, file);
  //     console.log(`[${config.lang}] lint: ${lintCmd}`);
  //   }
  // } else {
  //   if (mode === "health") {
  //     console.warn("NO LINTER DEFINED FOR", file);
  //   }
  // }
}
