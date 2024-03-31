const entrypoint = App.configDir + "/main.ts";
const outdir = "/tmp/ags/js";

try {
  await Utils.execAsync([
    "bun",
    "build",
    entrypoint,
    "--outdir",
    outdir,
    "--external",
    "resource://*",
    "--external",
    "gi://*",
  ]);
  await import("file://" + outdir + "/main.js");
} catch (e) {
  console.error(e);
}

export {};
