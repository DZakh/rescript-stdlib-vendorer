// Generated by ReScript, PLEASE EDIT WITH CARE

import * as S from "rescript-struct/src/S.mjs";
import * as Fs from "fs";
import * as Path from "path";
import * as Process from "process";
import * as Lib$RescriptStdlibCli from "../Lib.mjs";
import * as SourceDirs$RescriptStdlibCli from "../entities/SourceDirs.mjs";

function make(param) {
  return function () {
    var jsonObj = JSON.parse(Fs.readFileSync(Path.resolve(Process.cwd(), "lib/bs/.sourcedirs.json"), {
                encoding: "utf8"
              }).toString());
    return Lib$RescriptStdlibCli.Result.mapError(S.parseWith(jsonObj, SourceDirs$RescriptStdlibCli.struct), (function (error) {
                  return {
                          NAME: "PARSING_FAILURE",
                          VAL: S.$$Error.toString(error)
                        };
                }));
  };
}

export {
  make ,
}
/* fs Not a pure module */
