type t

let make: unit => t

let addIssue: (t, LintIssue.t) => unit

let getIssues: t => array<LintIssue.t>
