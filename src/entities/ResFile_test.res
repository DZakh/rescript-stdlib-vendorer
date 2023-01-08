open Ava

module CheckIsResFile = {
  test("checkIsResFile returns true for files with .res extensions", t => {
    t->Assert.deepEqual(ResFile.checkIsResFile(~dirItem="Demo.res"), true, ())
  })

  test("checkIsResFile returns true for files with .resi extensions", t => {
    t->Assert.deepEqual(ResFile.checkIsResFile(~dirItem="Demo.resi"), true, ())
  })

  test("checkIsResFile returns false for files with .js extensions", t => {
    t->Assert.deepEqual(ResFile.checkIsResFile(~dirItem="Demo.js"), false, ())
  })
}

module Lint = {
  test("lint empty file", t => {
    let resFile = ResFile.make(~content="", ~path="/Bar.res")
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(issues, [], ())
  })

  test("lint file containing prohibited module open", t => {
    let resFile = ResFile.make(~content="open Bad", ~path="/Bar.res")
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(
      issues,
      [
        LintIssue.make(
          ~path="/Bar.res",
          ~kind=ProhibitedModuleOpen({
            line: 1,
            prohibitedModuleName: ModuleName.TestData.make("Bad"),
          }),
        ),
      ],
      (),
    )
  })

  test(
    "lint file containing prohibited module open with ignoreIssuesBeforeStdlibOpen true and without stdlib open",
    t => {
      let resFile = ResFile.make(~content="open Bad", ~path="/Bar.res")
      let lintContext = LintContext.make()
      resFile->ResFile.lint(
        ~lintContext,
        ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
        ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
        ~ignoreIssuesBeforeStdlibOpen=true,
      )
      let issues = lintContext->LintContext.getIssues

      t->Assert.deepEqual(issues, [], ())
    },
  )

  test(
    "lint file containing prohibited module open with ignoreIssuesBeforeStdlibOpen true and with stdlib open in the begining of the file",
    t => {
      let resFile = ResFile.make(~content="open Stdlib\nopen Bad", ~path="/Bar.res")
      let lintContext = LintContext.make()
      resFile->ResFile.lint(
        ~lintContext,
        ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
        ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
        ~ignoreIssuesBeforeStdlibOpen=true,
      )
      let issues = lintContext->LintContext.getIssues

      t->Assert.deepEqual(
        issues,
        [
          LintIssue.make(
            ~path="/Bar.res",
            ~kind=ProhibitedModuleOpen({
              line: 2,
              prohibitedModuleName: ModuleName.TestData.make("Bad"),
            }),
          ),
        ],
        (),
      )
    },
  )

  test("lint file containing prohibited module open inside of a block", t => {
    let resFile = ResFile.make(
      ~content=["{", "  open Bad", "}"]->Array.joinWith("\n"),
      ~path="/Bar.res",
    )
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(
      issues,
      [
        LintIssue.make(
          ~path="/Bar.res",
          ~kind=ProhibitedModuleOpen({
            line: 2,
            prohibitedModuleName: ModuleName.TestData.make("Bad"),
          }),
        ),
      ],
      (),
    )
  })

  test("lint file containing prohibited nested module open", t => {
    let resFile = ResFile.make(~content="open Bad.Array", ~path="/Bar.res")
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(
      issues,
      [
        LintIssue.make(
          ~path="/Bar.res",
          ~kind=ProhibitedModuleOpen({
            line: 1,
            prohibitedModuleName: ModuleName.TestData.make("Bad"),
          }),
        ),
      ],
      (),
    )
  })

  test("lint file containing multiple prohibited module open", t => {
    let resFile = ResFile.make(~content="open Bad\nopen Stdlib\nopen Belt", ~path="/Bar.res")
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad"), ModuleName.TestData.make("Belt")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(
      issues,
      [
        LintIssue.make(
          ~path="/Bar.res",
          ~kind=ProhibitedModuleOpen({
            line: 1,
            prohibitedModuleName: ModuleName.TestData.make("Bad"),
          }),
        ),
        LintIssue.make(
          ~path="/Bar.res",
          ~kind=ProhibitedModuleOpen({
            line: 3,
            prohibitedModuleName: ModuleName.TestData.make("Belt"),
          }),
        ),
      ],
      (),
    )
  })

  test("lint file containing prohibited module include", t => {
    let resFile = ResFile.make(~content="include Bad", ~path="/Bar.res")
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(
      issues,
      [
        LintIssue.make(
          ~path="/Bar.res",
          ~kind=ProhibitedModuleInclude({
            line: 1,
            prohibitedModuleName: ModuleName.TestData.make("Bad"),
          }),
        ),
      ],
      (),
    )
  })

  test("lint file containing prohibited module include inside of a block", t => {
    let resFile = ResFile.make(
      ~content=["{", "  include Bad", "}"]->Array.joinWith("\n"),
      ~path="/Bar.res",
    )
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(
      issues,
      [
        LintIssue.make(
          ~path="/Bar.res",
          ~kind=ProhibitedModuleInclude({
            line: 2,
            prohibitedModuleName: ModuleName.TestData.make("Bad"),
          }),
        ),
      ],
      (),
    )
  })

  test("lint file containing prohibited nested module include", t => {
    let resFile = ResFile.make(~content="include Bad.Array", ~path="/Bar.res")
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(
      issues,
      [
        LintIssue.make(
          ~path="/Bar.res",
          ~kind=ProhibitedModuleInclude({
            line: 1,
            prohibitedModuleName: ModuleName.TestData.make("Bad"),
          }),
        ),
      ],
      (),
    )
  })

  test("lint file containing prohibited module assign", t => {
    let resFile = ResFile.make(~content="module Foo = Bad", ~path="/Bar.res")
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(
      issues,
      [
        LintIssue.make(
          ~path="/Bar.res",
          ~kind=ProhibitedModuleAssign({
            line: 1,
            prohibitedModuleName: ModuleName.TestData.make("Bad"),
          }),
        ),
      ],
      (),
    )
  })

  test("lint file containing prohibited module assign inside of a block", t => {
    let resFile = ResFile.make(
      ~content=["{", "  module Foo = Bad", "}"]->Array.joinWith("\n"),
      ~path="/Bar.res",
    )
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(
      issues,
      [
        LintIssue.make(
          ~path="/Bar.res",
          ~kind=ProhibitedModuleAssign({
            line: 2,
            prohibitedModuleName: ModuleName.TestData.make("Bad"),
          }),
        ),
      ],
      (),
    )
  })

  test("lint file containing prohibited nested module assign", t => {
    let resFile = ResFile.make(~content="module Array = Bad.Array", ~path="/Bar.res")
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(
      issues,
      [
        LintIssue.make(
          ~path="/Bar.res",
          ~kind=ProhibitedModuleAssign({
            line: 1,
            prohibitedModuleName: ModuleName.TestData.make("Bad"),
          }),
        ),
      ],
      (),
    )
  })

  test("lint file containing prohibited module usage", t => {
    let resFile = ResFile.make(~content=`Bad.log("Foo")`, ~path="/Bar.res")
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(
      issues,
      [
        LintIssue.make(
          ~path="/Bar.res",
          ~kind=ProhibitedModuleUsage({
            line: 1,
            prohibitedModuleName: ModuleName.TestData.make("Bad"),
          }),
        ),
      ],
      (),
    )
  })

  test("lint file containing module similarly called to the prohibited one", t => {
    let resFile = ResFile.make(
      ~content=[
        "open Bads",
        "open MBad",
        "include Bada",
        "include VBad",
        "module Bad = VBad",
        "module Bad = Bads",
        "GBad.log(1)",
        "Bad2.log(1)",
      ]->Array.joinWith("\n"),
      ~path="/Bar.res",
    )
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(issues, [], ())
  })

  test("lint stdlib module which uses prohibited ones", t => {
    let resFile = ResFile.make(~content="Bad.log(1)", ~path="/stdlib/Stdlib.res")
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(issues, [], ())
  })

  test("lint stdlib submodule which uses prohibited ones", t => {
    let resFile = ResFile.make(~content="Bad.log(1)", ~path="/stdlib/Stdlib_Foo.res")
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(issues, [], ())
  })

  test("lint stdlib module located in some random directory", t => {
    let resFile = ResFile.make(~content="Bad.log(1)", ~path="/some-random-directory/Stdlib.res")
    let lintContext = LintContext.make()
    resFile->ResFile.lint(
      ~lintContext,
      ~prohibitedModuleNames=[ModuleName.TestData.make("Bad")],
      ~stdlibModuleName=ModuleName.TestData.make("Stdlib"),
      ~ignoreIssuesBeforeStdlibOpen=false,
    )
    let issues = lintContext->LintContext.getIssues

    t->Assert.deepEqual(
      issues,
      [
        LintIssue.make(
          ~path="/some-random-directory/Stdlib.res",
          ~kind=InvalidStdlibParentDirName({
            stdlibParentDirName: "some-random-directory",
          }),
        ),
      ],
      (),
    )
  })
}
