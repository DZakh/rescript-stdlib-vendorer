open Ava

module GetLink = {
  test("getLink successfully returns link with line", t => {
    t->Assert.deepEqual(
      LintIssue.make(
        ~kind=ProhibitedModuleOpen({
          line: 5,
          prohibitedModuleName: ModuleName.TestData.make("Js"),
        }),
        ~path="/path/LintIssue_test.res",
      )->LintIssue.getLink,
      "/path/LintIssue_test.res:5",
      (),
    )
  })

  test("getLink successfully returns link without line", t => {
    t->Assert.deepEqual(
      LintIssue.make(
        ~kind=InvalidStdlibParentDirName({
          stdlibParentDirName: "stdlib",
        }),
        ~path="/path/LintIssue_test.res",
      )->LintIssue.getLink,
      "/path/LintIssue_test.res",
      (),
    )
  })
}

module GetMessage = {
  test("getMessage with InvalidStdlibParentDirName", t => {
    t->Assert.deepEqual(
      LintIssue.make(
        ~kind=InvalidStdlibParentDirName({
          stdlibParentDirName: "stdlib",
        }),
        ~path="/path/LintIssue_test.res",
      )->LintIssue.getMessage,
      `The "stdlib" is an invalid directory name for custom standary library related files. Put the files to the directory with the name "stdlib" to make it easier to find them.`,
      (),
    )
  })

  test("getMessage with ProhibitedModuleOpen", t => {
    t->Assert.deepEqual(
      LintIssue.make(
        ~kind=ProhibitedModuleOpen({
          prohibitedModuleName: ModuleName.TestData.make("Js"),
          line: 5,
        }),
        ~path="/path/LintIssue_test.res",
      )->LintIssue.getMessage,
      `Found "Js" module open.`,
      (),
    )
  })

  test("getMessage with ProhibitedModuleInclude", t => {
    t->Assert.deepEqual(
      LintIssue.make(
        ~kind=ProhibitedModuleInclude({
          prohibitedModuleName: ModuleName.TestData.make("Js"),
          line: 5,
        }),
        ~path="/path/LintIssue_test.res",
      )->LintIssue.getMessage,
      `Found "Js" module include.`,
      (),
    )
  })

  test("getMessage with ProhibitedModuleUsage", t => {
    t->Assert.deepEqual(
      LintIssue.make(
        ~kind=ProhibitedModuleUsage({
          prohibitedModuleName: ModuleName.TestData.make("Js"),
          line: 5,
        }),
        ~path="/path/LintIssue_test.res",
      )->LintIssue.getMessage,
      `Found "Js" module usage.`,
      (),
    )
  })

  test("getMessage with ProhibitedModuleAssign", t => {
    t->Assert.deepEqual(
      LintIssue.make(
        ~kind=ProhibitedModuleAssign({
          prohibitedModuleName: ModuleName.TestData.make("Js"),
          line: 5,
        }),
        ~path="/path/LintIssue_test.res",
      )->LintIssue.getMessage,
      `Found "Js" module usage.`,
      (),
    )
  })
}
