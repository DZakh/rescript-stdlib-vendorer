import fs from "fs";

const packageJson = JSON.parse(fs.readFileSync("./package.json", "utf8"));

const tests = packageJson.ava.files;

export default () => ({
  files: ["src/**/*.bs.mjs", "fixtures/**"].concat(
    tests.map((testPattern) => ({
      pattern: testPattern,
      ignore: true,
    }))
  ),
  tests,
  env: {
    type: "node",
    params: {
      runner: "--experimental-vm-modules",
    },
  },
  testFramework: "ava",
});
