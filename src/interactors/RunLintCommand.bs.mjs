// Generated by ReScript, PLEASE EDIT WITH CARE

import * as LintIssue from "../entities/LintIssue.bs.mjs";
import * as Colorette from "colorette";

function make(lint, exitConsoleWithError) {
  return function (config) {
    var error = lint(config);
    if (error.TAG === "Ok") {
      return ;
    }
    var error$1 = error._0;
    if (typeof error$1 !== "object") {
      return exitConsoleWithError("Couldn't find rescript compiler artifacts in the \"./lib/bs/\" directory. Try to run compiler before the lint script.");
    }
    switch (error$1.TAG) {
      case "ResConfigParseFailure" :
          return exitConsoleWithError("Failed to parse \"bsconfig.json\": " + error$1._0);
      case "SourceDirsParseFailure" :
          return exitConsoleWithError("Failed to parse \".sourcedirs.json\". Check that you use compatible ReScript version. Parsing error: " + error$1._0);
      case "ResConfigHasOpenedProhibitedModule" :
          return exitConsoleWithError("Lint failed: Found globally opened module " + error$1._0);
      case "LintFailedWithIssues" :
          var message = error$1._0.map(function (lintIssue) {
                    return [
                              Colorette.underline(LintIssue.getLink(lintIssue)),
                              LintIssue.getMessage(lintIssue)
                            ].join("\n");
                  }).concat([Colorette.bold("Use the vendored standard library instead. Read more at: " + Colorette.underline("https://github.com/DZakh/rescript-stdlib-vendorer"))]).join("\n\n");
          return exitConsoleWithError(message);
      
    }
  };
}

export {
  make ,
}
/* colorette Not a pure module */
