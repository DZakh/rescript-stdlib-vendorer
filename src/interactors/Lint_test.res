open Ava

test("Fails when can't parse bsconfig", t => {
  let loadBsConfig = (. ()) => Error(Port.LoadBsConfig.ParsingFailure("Some reason"))
  let loadSourceDirs = (. ()) => t->Assert.fail("Shouldn't call loadSourceDirs")
  let lint = Lint.make(~projectPath="", ~loadBsConfig, ~loadSourceDirs)

  t->Assert.deepEqual(lint(.), Error(BsConfigParseFailure("Some reason")), ())
})

test("Fails with globally opened prohibited module", t => {
  let loadBsConfig = (. ()) => Ok(BsConfig.TestData.make(~bscFlags=["-open Belt"]))
  let loadSourceDirs = (. ()) => t->Assert.fail("Shouldn't call loadSourceDirs")
  let lint = Lint.make(~projectPath="", ~loadBsConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(.),
    Error(BsConfigHasOpenedProhibitedModule(ModuleName.TestData.make("Belt"))),
    (),
  )
})

test("Fails when can't parse sourcedirs.json", t => {
  let loadBsConfig = (. ()) => Ok(BsConfig.TestData.make(~bscFlags=[]))
  let loadSourceDirs = (. ()) => Error(Port.LoadSourceDirs.ParsingFailure("Some reason"))
  let lint = Lint.make(~projectPath="", ~loadBsConfig, ~loadSourceDirs)

  t->Assert.deepEqual(lint(.), Error(SourceDirsParseFailure("Some reason")), ())
})

test("Fails when can't find rescript artifacts", t => {
  let loadBsConfig = (. ()) => Ok(BsConfig.TestData.make(~bscFlags=[]))
  let loadSourceDirs = (. ()) => Error(Port.LoadSourceDirs.RescriptCompilerArtifactsNotFound)
  let lint = Lint.make(~projectPath="", ~loadBsConfig, ~loadSourceDirs)

  t->Assert.deepEqual(lint(.), Error(RescriptCompilerArtifactsNotFound), ())
})

test("Doesn't complain with valid project", t => {
  let loadBsConfig = (. ()) => Ok(BsConfig.TestData.make(~bscFlags=[]))
  let loadSourceDirs = (. ()) => Ok(SourceDirs.TestData.make(~projectDirs=["src"]))
  let lint = Lint.make(~projectPath="fixtures/Lint/valid", ~loadBsConfig, ~loadSourceDirs)

  t->Assert.deepEqual(lint(.), Ok(), ())
})

test("Complains with invalid project", t => {
  let loadBsConfig = (. ()) => Ok(BsConfig.TestData.make(~bscFlags=[]))
  let loadSourceDirs = (. ()) => Ok(SourceDirs.TestData.make(~projectDirs=["src"]))
  let lint = Lint.make(~projectPath="fixtures/Lint/invalid", ~loadBsConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(.),
    Error(
      LintFailedWithIssues([
        LintIssue.make(
          ~kind=ProhibitedModuleUsage({
            line: 1,
            prohibitedModuleName: ModuleName.TestData.make("Js"),
          }),
          ~path=NodeJs.Path.resolve(["fixtures/Lint/invalid/src/Demo.res"]),
        ),
      ]),
    ),
    (),
  )
})
