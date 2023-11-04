// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Fs from "fs";
import * as Path from "path";
import * as Config from "../entities/Config.bs.mjs";
import * as ResFile from "../entities/ResFile.bs.mjs";
import * as ResConfig from "../entities/ResConfig.bs.mjs";
import * as ModuleName from "../entities/ModuleName.bs.mjs";
import * as SourceDirs from "../entities/SourceDirs.bs.mjs";
import * as LintContext from "../entities/LintContext.bs.mjs";
import * as Core__Result from "@dzakh/rescript-core/src/Core__Result.bs.mjs";

function make(loadResConfig, loadSourceDirs) {
  return function (config) {
    return Core__Result.flatMap(Core__Result.flatMap(Core__Result.flatMap(Core__Result.mapError(loadResConfig(config), (function (loadResConfigError) {
                              return {
                                      TAG: "ResConfigParseFailure",
                                      _0: loadResConfigError._0
                                    };
                            })), (function (resConfig) {
                          var match = ResConfig.lint(resConfig, ModuleName.defaultProhibitedModuleNames);
                          if (match.TAG === "Ok") {
                            return {
                                    TAG: "Ok",
                                    _0: resConfig
                                  };
                          } else {
                            return {
                                    TAG: "Error",
                                    _0: {
                                      TAG: "ResConfigHasOpenedProhibitedModule",
                                      _0: match._0.VAL
                                    }
                                  };
                          }
                        })), (function (resConfig) {
                      var sourceDirs = loadSourceDirs(config);
                      if (sourceDirs.TAG === "Ok") {
                        return {
                                TAG: "Ok",
                                _0: [
                                  resConfig,
                                  sourceDirs._0
                                ]
                              };
                      }
                      var loadSourceDirsError = sourceDirs._0;
                      var tmp;
                      tmp = typeof loadSourceDirsError !== "object" ? "RescriptCompilerArtifactsNotFound" : ({
                            TAG: "SourceDirsParseFailure",
                            _0: loadSourceDirsError._0
                          });
                      return {
                              TAG: "Error",
                              _0: tmp
                            };
                    })), (function (param) {
                  var resConfig = param[0];
                  var resFiles = [];
                  SourceDirs.getProjectDirs(param[1]).forEach(function (sourceDir) {
                        var fullDirPath = Path.resolve(Config.getProjectPath(config), sourceDir);
                        Fs.readdirSync(fullDirPath).forEach(function (dirItem) {
                              if (!(ResFile.checkIsResFile(dirItem) && !Config.checkIsIgnoredPath(config, sourceDir + "/" + dirItem))) {
                                return ;
                              }
                              var resFilePath = fullDirPath + "/" + dirItem;
                              var resFile = ResFile.make(Fs.readFileSync(resFilePath, {
                                          encoding: "utf8"
                                        }).toString(), resFilePath);
                              resFiles.push(resFile);
                            });
                      });
                  var lintContext = LintContext.make();
                  resFiles.forEach(function (resFile) {
                        ResFile.lint(resFile, lintContext, ModuleName.defaultProhibitedModuleNames, Config.getStdlibModuleName(config), Config.checkShouldIngoreResFileIssuesBeforeStdlibOpen(config, resConfig));
                      });
                  var lintIssues = LintContext.getIssues(lintContext);
                  if (lintIssues.length !== 0) {
                    return {
                            TAG: "Error",
                            _0: {
                              TAG: "LintFailedWithIssues",
                              _0: lintIssues
                            }
                          };
                  } else {
                    return {
                            TAG: "Ok",
                            _0: undefined
                          };
                  }
                }));
  };
}

export {
  make ,
}
/* fs Not a pure module */
