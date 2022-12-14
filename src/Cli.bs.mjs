// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Lint from "./interactors/Lint.bs.mjs";
import * as RunCli from "./interactors/RunCli.bs.mjs";
import * as Process from "process";
import * as LoadBsConfig from "./interactors/LoadBsConfig.bs.mjs";
import * as LoadSourceDirs from "./interactors/LoadSourceDirs.bs.mjs";
import * as RunHelpCommand from "./interactors/RunHelpCommand.bs.mjs";
import * as RunLintCommand from "./interactors/RunLintCommand.bs.mjs";
import * as RunHelpLintCommand from "./interactors/RunHelpLintCommand.bs.mjs";

function exitConsoleWithError(message) {
  console.log(message);
  Process.exit(1);
}

var runCli = RunCli.make(RunLintCommand.make(Lint.make(LoadBsConfig.make(undefined), LoadSourceDirs.make(undefined)), exitConsoleWithError), RunHelpCommand.make(undefined), RunHelpLintCommand.make(undefined), exitConsoleWithError);

runCli();

export {
  
}
/* runCli Not a pure module */
