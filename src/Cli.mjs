// Generated by ReScript, PLEASE EDIT WITH CARE

import * as RunCli$RescriptStdlibCli from "./interactors/RunCli.mjs";
import * as LoadBsConfig$RescriptStdlibCli from "./interactors/LoadBsConfig.mjs";
import * as LoadSourceDirs$RescriptStdlibCli from "./interactors/LoadSourceDirs.mjs";
import * as RunLintCommand$RescriptStdlibCli from "./interactors/RunLintCommand.mjs";

var runCli = RunCli$RescriptStdlibCli.make(RunLintCommand$RescriptStdlibCli.make(LoadBsConfig$RescriptStdlibCli.make(undefined), LoadSourceDirs$RescriptStdlibCli.make(undefined)), (function () {
        console.log("Help");
      }), (function () {
        console.log("Lint help");
      }));

runCli();

export {
  runCli ,
}
/* runCli Not a pure module */