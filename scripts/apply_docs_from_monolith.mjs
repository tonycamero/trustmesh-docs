import fs from "fs/promises";
import path from "path";

const src = process.argv[2] || "docs_update_2025-08-10.md";
const text = await fs.readFile(src, "utf8");

// Delimiters:
// ===== FILE: <path> =====
// ...content...
// ===== END FILE =====
const re = /^===== FILE:\s*(.+?)\s*=====[\r\n]+([\s\S]*?)^[ \t]*===== END FILE =====/gm;

let match, count = 0;
while ((match = re.exec(text)) !== null) {
  const filePath = match[1].trim();
  const body = match[2].replace(/\s+$/, "") + "\n";
  const abs = path.resolve(process.cwd(), filePath);
  await fs.mkdir(path.dirname(abs), { recursive: true });
  await fs.writeFile(abs, body, "utf8");
  console.log(" wrote", filePath);
  count++;
}
if (!count) {
  console.error("No blocks found. Ensure delimiters are exactly '===== FILE:' and '===== END FILE ====='.");
  process.exit(1);
}
console.log(`\nDone. Updated ${count} files.`);
