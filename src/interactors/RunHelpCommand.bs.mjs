// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Colorette from "colorette";

function make() {
  return function () {
    console.log([
            "Usage: cli [command] [options]",
            "",
            "Commands:",
            "  " + Colorette.bold("help") + " - Display this message",
            "  " + Colorette.bold("help <command>") + " - Show more information about a command",
            "  " + Colorette.bold("lint") + " - Lint that you use your vendored ReScript standard library over Js, Belt, etc",
            "",
            "You can find more information about the reasoning behind the tool in the documentation: " + Colorette.underline("https://github.com/DZakh/rescript-stdlib-vendorer"),
            ""
          ].join("\n"));
  };
}

export {
  make ,
}
/* colorette Not a pure module */
