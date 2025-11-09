import { join } from "node:path";
import { getAllFiles, getChangedFiles } from "./shared";
import languageConfigs, { type LanguageConfig } from "./langs";

const mode = Bun.argv[2] || "health";
const rootDir = join(import.meta.dirname, "../..");

if (!["health", "changed", "all"].includes(mode)) {
  console.error(`Invalid mode: ${mode}`);
  console.error("Usage: bun run format.ts [health|changed|all]");
  process.exit(1);
}

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

async function binaryExists(binary: string): Promise<boolean> {
  try {
    const proc = Bun.spawn(["which", binary], {
      stdout: "pipe",
      stderr: "pipe",
    });
    await proc.exited;
    return proc.exitCode === 0;
  } catch {
    return false;
  }
}

interface CommandResult {
  success: boolean;
  stdout: string;
  stderr: string;
  exitCode: number;
}

async function executeCommand(command: string): Promise<CommandResult> {
  try {
    const proc = Bun.spawn(["sh", "-c", command], {
      stdout: "pipe",
      stderr: "pipe",
    });

    const stdout = await new Response(proc.stdout).text();
    const stderr = await new Response(proc.stderr).text();
    await proc.exited;

    return {
      success: proc.exitCode === 0,
      stdout: stdout.trim(),
      stderr: stderr.trim(),
      exitCode: proc.exitCode || 0,
    };
  } catch (error) {
    return {
      success: false,
      stdout: "",
      stderr: error instanceof Error ? error.message : String(error),
      exitCode: 1,
    };
  }
}

function getLanguageConfig(filePath: string): LanguageConfig | null {
  const basename = filePath.split("/").pop() || "";
  const ext = basename.includes(".")
    ? `.${basename.split(".").pop()}`
    : basename;

  return languageConfigs.find((config) => config.ext.includes(ext)) ?? null;
}

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
