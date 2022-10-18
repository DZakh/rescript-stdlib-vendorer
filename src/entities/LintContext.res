type t = array<LintIssue.t>

let make = () => []

let addIssue = (lintContext, lintIssue) => {
  lintContext->Js.Array2.push(lintIssue)->ignore
}

let getIssues = lintContext => lintContext
