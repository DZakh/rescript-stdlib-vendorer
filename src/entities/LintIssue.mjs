// Generated by ReScript, PLEASE EDIT WITH CARE


function make(path, line, kind) {
  return {
          path: path,
          line: line,
          kind: kind
        };
}

function getLink(lintIssue) {
  return "" + lintIssue.path + ":" + lintIssue.line.toString() + "";
}

function getMessage(lintIssue) {
  var moduleName = lintIssue.kind;
  switch (moduleName.TAG | 0) {
    case /* ProhibitedModuleOpen */0 :
        return "Found \"" + moduleName._0 + "\" module open.";
    case /* ProhibitedModuleInclude */1 :
        return "Found \"" + moduleName._0 + "\" module include.";
    case /* ProhibitedModuleAssign */2 :
    case /* ProhibitedModuleUsage */3 :
        return "Found \"" + moduleName._0 + "\" module usage.";
    
  }
}

export {
  make ,
  getLink ,
  getMessage ,
}
/* No side effect */