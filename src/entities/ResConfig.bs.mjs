// Generated by ReScript, PLEASE EDIT WITH CARE

import * as ModuleName from "./ModuleName.bs.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Core__Option from "@dzakh/rescript-core/src/Core__Option.bs.mjs";
import * as Core__Result from "@dzakh/rescript-core/src/Core__Result.bs.mjs";
import * as S$RescriptSchema from "rescript-schema/src/S.bs.mjs";

function getGlobalyOpenedModulesSet(resConfig) {
  var set = new Set();
  resConfig.bscFlags.forEach(function (bscFlag) {
        Core__Option.forEach(ModuleName.fromBscFlag(bscFlag), (function (moduleName) {
                set.add(moduleName);
              }));
      });
  return set;
}

function hasGloballyOpenedModule(resConfig, moduleName) {
  var globalyOpenedModulesSet = getGlobalyOpenedModulesSet(resConfig);
  return globalyOpenedModulesSet.has(moduleName);
}

function lint(resConfig, prohibitedModuleNames) {
  var globalyOpenedModulesSet = getGlobalyOpenedModulesSet(resConfig);
  var maybeOpenedProhibitedModule = prohibitedModuleNames.find(function (prohibitedModule) {
        return globalyOpenedModulesSet.has(prohibitedModule);
      });
  if (maybeOpenedProhibitedModule !== undefined) {
    return {
            TAG: "Error",
            _0: {
              NAME: "HAS_OPENED_PROHIBITED_MODULE",
              VAL: Caml_option.valFromOption(maybeOpenedProhibitedModule)
            }
          };
  } else {
    return {
            TAG: "Ok",
            _0: undefined
          };
  }
}

var struct = S$RescriptSchema.object(function (s) {
      return {
              bscFlags: s.o("bsc-flags", S$RescriptSchema.array(S$RescriptSchema.string), [])
            };
    });

function fromJsonString(jsonString) {
  return Core__Result.mapError(S$RescriptSchema.parseJsonStringWith(jsonString, struct), S$RescriptSchema.$$Error.message);
}

function make(bscFlags) {
  return {
          bscFlags: bscFlags
        };
}

var TestData = {
  make: make
};

export {
  lint ,
  hasGloballyOpenedModule ,
  fromJsonString ,
  TestData ,
}
/* struct Not a pure module */
