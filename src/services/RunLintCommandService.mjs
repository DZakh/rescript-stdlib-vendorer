// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Fs from "fs";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";
import * as Lib$RescriptStdlibCli from "../Lib.mjs";
import * as BsConfig$RescriptStdlibCli from "../entities/BsConfig.mjs";
import * as SourceDirs$RescriptStdlibCli from "../entities/SourceDirs.mjs";

function make(loadBsConfig, loadSourceDirs) {
  var standardLibModules = [
    "Belt",
    "Js",
    "ReScriptJs"
  ];
  return function () {
    return Belt_Result.map(Belt_Result.flatMap(Belt_Result.flatMap(Lib$RescriptStdlibCli.Result.mapError(loadBsConfig(), (function (loadBsConfigError) {
                              return {
                                      NAME: "BS_CONFIG_PARSE_FAILURE",
                                      VAL: loadBsConfigError.VAL
                                    };
                            })), (function (bsConfig) {
                          var globalyOpenedModules = BsConfig$RescriptStdlibCli.getGlobalyOpenedModules(bsConfig);
                          var maybeOpenedStandardLibModule = standardLibModules.find(function (standardLibModule) {
                                return globalyOpenedModules.some(function (globalyOpenedModule) {
                                            return globalyOpenedModule === standardLibModule;
                                          });
                              });
                          if (maybeOpenedStandardLibModule !== undefined) {
                            return {
                                    TAG: /* Error */1,
                                    _0: {
                                      NAME: "HAS_GLOBALY_OPENED_STDLIB",
                                      VAL: maybeOpenedStandardLibModule
                                    }
                                  };
                          } else {
                            return {
                                    TAG: /* Ok */0,
                                    _0: undefined
                                  };
                          }
                        })), (function (param) {
                      return Lib$RescriptStdlibCli.Result.mapError(loadSourceDirs(), (function (loadSourceDirsError) {
                                    return {
                                            NAME: "SOURCE_DIRS_PARSE_FAILURE",
                                            VAL: loadSourceDirsError.VAL
                                          };
                                  }));
                    })), (function (sourceDirs) {
                  var resFilePaths = SourceDirs$RescriptStdlibCli.getProjectDirs(sourceDirs).flatMap(function (sourceDir) {
                        return Fs.readdirSync(sourceDir).filter(function (dirItem) {
                                      return dirItem.endsWith(".res");
                                    }).map(function (dirItem) {
                                    return "" + sourceDir + "/" + dirItem + "";
                                  });
                      });
                  console.log(resFilePaths);
                }));
  };
}

export {
  make ,
}
/* fs Not a pure module */
