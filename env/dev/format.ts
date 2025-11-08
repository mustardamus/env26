import { join } from "node:path";
import { getAllFiles } from "./shared";

const rootDir = join(import.meta.dirname, "../..");
const files = await getAllFiles(rootDir);

console.log(files);
