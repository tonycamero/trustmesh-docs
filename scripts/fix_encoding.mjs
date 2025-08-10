import fs from "fs/promises";
import path from "path";

const IGNORES = new Set(["node_modules",".git"]);
const replacers = [
  [/<97>/g, "—"],                 // CP1252 en dash artifact
  [/\s\uFFFD\s/g, " — "],         // replacement char between words
  [/\uFFFD/g, "-"],               // fallback for lone �
  [/\s\?\s/g, " → "],             // lost arrows
  [/(\w)�s/g, "$1's"],            // user�s -> user's
];

async function* walk(d){for (const e of await fs.readdir(d,{withFileTypes:true})) {
  if (IGNORES.has(e.name)) continue;
  const p = path.join(d,e.name);
  if (e.isDirectory()) yield* walk(p); else if (p.endsWith(".md")) yield p;
}}
let changed=0;
for await (const f of walk(".")) {
  let t = await fs.readFile(f,"utf8"), o=t;
  for (const [re, rep] of replacers) t = t.replace(re, rep);
  if (t!==o) { await fs.writeFile(f,t,"utf8"); console.log("fixed", f); changed++; }
}
console.log("done,", changed, "files updated");
