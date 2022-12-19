import fs from "fs";

const packageJson = JSON.parse(fs.readFileSync("./package.json", "utf8"));

const tests = packageJson.ava.files;

export default () => ({
  files: [
    "src/**/*.bs.mjs",
    { pattern: "fixtures/**", instrument: false },
    { pattern: "stdlib/**", instrument: false },
  ].concat(
    tests.map((testPattern) => ({
      pattern: testPattern,
      ignore: true,
    }))
  ),
  tests: tests.concat(
    // https://github.com/wallabyjs/public/issues/662
    "!src/Cli_test.bs.mjs"
  ),
  env: {
    type: "node",
    params: {
      runner: "--experimental-vm-modules",
    },
  },
  testFramework: "ava",
  dot: true,
});
