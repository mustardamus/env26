import { readdir, readFile, stat } from "node:fs/promises";
import { join } from "node:path";

function matchesPattern(filePath: string, pattern: string): boolean {
  const isDirectoryPattern = pattern.endsWith("/");
  let cleanPattern = isDirectoryPattern ? pattern.slice(0, -1) : pattern;
  const isRootRelative = cleanPattern.startsWith("/");

  if (isRootRelative) {
    cleanPattern = cleanPattern.slice(1);
  }

  let regex: RegExp;
  let regexPattern = cleanPattern
    // Escape regex special characters except * and ?
    .replace(/[.+^${}()|[\]\\]/g, "\\$&")
    // Replace ** with placeholder
    .replace(/\\\*\\\*/g, "§GLOBSTAR§")
    // Replace * with regex for anything except /
    .replace(/\\\*/g, "[^/]*")
    // Replace § GLOBSTAR§ with regex for any characters including /
    .replace(/§GLOBSTAR§/g, ".*")
    // Replace ? with single character (except /)
    .replace(/\\\?/g, "[^/]");

  if (isRootRelative) {
    if (isDirectoryPattern) {
      // Match directory and everything inside it
      regex = new RegExp(`^${regexPattern}(/.*)?$`);
    } else {
      // Match exact file or directory
      regex = new RegExp(`^${regexPattern}(/.*)?$`);
    }
  } else {
    // Can match anywhere in path
    if (isDirectoryPattern) {
      // Match directory name anywhere and everything inside
      regex = new RegExp(`(^|/)${regexPattern}(/.*)?$`);
    } else {
      // Match filename/dirname anywhere
      regex = new RegExp(`(^|/)${regexPattern}(/.*)?$`);
    }
  }

  return regex.test(filePath);
}

function isIgnored(filePath: string, patterns: string[]): boolean {
  return patterns.some((pattern) => matchesPattern(filePath, pattern));
}

export async function getAllFiles(rootDir: string, ignorePatterns: string[]) {
  const gitignorePath = join(rootDir, ".gitignore");
  const gitignoreContent = await readFile(gitignorePath, "utf-8");
  const patterns = [
    ".git/",
    ...ignorePatterns,
    ...gitignoreContent
      .split("\n")
      .map((line) => line.trim())
      .filter((line) => line && !line.startsWith("#")),
  ];
  const entries = await readdir(rootDir, {
    recursive: true,
    withFileTypes: true,
  });

  return entries
    .filter((entry) => entry.isFile())
    .map((entry) => join(entry.parentPath, entry.name))
    .filter((file) => !isIgnored(file, patterns));
}
