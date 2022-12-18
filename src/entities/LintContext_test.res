open Ava

test("LintContext works", t => {
  let lintIssue = LintIssue.make(
    ~path="/path/Module.res",
    ~kind=InvalidStdlibParentDirName({stdlibParentDirName: "foo"}),
  )
  let lintContext = LintContext.make()

  t->Assert.deepEqual(lintContext->LintContext.getIssues, [], ())
  lintContext->LintContext.addIssue(lintIssue)
  t->Assert.deepEqual(lintContext->LintContext.getIssues, [lintIssue], ())
})
