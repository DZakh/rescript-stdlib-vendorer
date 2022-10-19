open Stdlib

type t = array<LintIssue.t>

let make = () => []

let addIssue = (lintContext, lintIssue) => {
  lintContext->Array.push(lintIssue)->ignore
}

let getIssues = lintContext => lintContext
