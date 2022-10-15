// Generated by ReScript, PLEASE EDIT WITH CARE

import * as S from "rescript-struct/src/S.mjs";
import * as Fs from "fs";
import * as Path from "path";
import * as Process from "process";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";
import * as Lib$RescriptStdlibCli from "../Lib.mjs";
import * as BsConfig$RescriptStdlibCli from "../BsConfig.mjs";

function make(param) {
  return function () {
    var tmp;
    try {
      tmp = {
        TAG: /* Ok */0,
        _0: JSON.parse(Fs.readFileSync(Path.resolve(Process.cwd(), "bsconfig.json"), {
                    encoding: "utf8"
                  }).toString())
      };
    }
    catch (exn){
      tmp = {
        TAG: /* Error */1,
        _0: "LOAD_FAILURE"
      };
    }
    return Belt_Result.flatMap(tmp, (function (jsonObj) {
                  var sourceStruct = S.union([
                        S.transform(S.string(undefined), (function (dir) {
                                return BsConfig$RescriptStdlibCli.Source.make(dir, /* Without */1);
                              }), undefined, undefined),
                        S.$$Object.strict(S.transform(S.object2([
                                      "dir",
                                      S.string(undefined)
                                    ], [
                                      "subdirs",
                                      S.defaulted(S.option(S.union([
                                                    S.transform(S.bool(undefined), (function (bool) {
                                                            if (bool) {
                                                              return /* Recursive */0;
                                                            } else {
                                                              return /* Without */1;
                                                            }
                                                          }), undefined, undefined),
                                                    S.transform(S.array(S.string(undefined)), (function (specific) {
                                                            return /* Specific */{
                                                                    _0: specific
                                                                  };
                                                          }), undefined, undefined)
                                                  ])), /* Without */1)
                                    ]), (function (param) {
                                    return BsConfig$RescriptStdlibCli.Source.make(param[0], param[1]);
                                  }), undefined, undefined))
                      ]);
                  var struct = S.transform(S.object2([
                            "bsc-flags",
                            S.defaulted(S.option(S.array(S.string(undefined))), [])
                          ], [
                            "sources",
                            S.union([
                                  S.transform(sourceStruct, (function (source) {
                                          return [source];
                                        }), undefined, undefined),
                                  S.array(sourceStruct)
                                ])
                          ]), (function (param) {
                          return BsConfig$RescriptStdlibCli.make(param[1], param[0]);
                        }), undefined, undefined);
                  return Lib$RescriptStdlibCli.Result.mapError(S.parseWith(jsonObj, struct), (function (error) {
                                return {
                                        NAME: "PARSING_FAILURE",
                                        VAL: S.$$Error.toString(error)
                                      };
                              }));
                }));
  };
}

export {
  make ,
}
/* fs Not a pure module */