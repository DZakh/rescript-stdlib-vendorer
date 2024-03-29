// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Colorette from "colorette";

function make() {
  return function () {
    console.log([
            "",
            "Lint that you use your vendored ReScript standard library over Js, Belt, etc.",
            "",
            "Options:",
            " " + Colorette.bold("--project-path String") + " - Path to the project directory. It should point to where bsconfig.json is located (defaults to the current directory).",
            " " + Colorette.bold("--ignore-without-stdlib-open") + " - Whether linter should ignore files that don't have globally opened vendored stdlib. Convenient for gradual adoption.",
            " " + Colorette.bold("--ignore-path [String]") + " - Paths of files to ignore.",
            ""
          ].join("\n"));
  };
}

export {
  make ,
}
/* colorette Not a pure module */
