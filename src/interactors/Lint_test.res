open Ava

test("Fails when can't parse bsconfig", t => {
  let loadBsConfig = (. ~config as _) => Error(Port.LoadBsConfig.ParsingFailure("Some reason"))
  let loadSourceDirs = (. ~config as _) => t->Assert.fail("Shouldn't call loadSourceDirs")
  let lint = Lint.make(~loadBsConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(. ~config=Config.make(~projectPath="", ~ignoreWithoutStdlibOpen=false)),
    Error(BsConfigParseFailure("Some reason")),
    (),
  )
})

test("Fails with globally opened prohibited module", t => {
  let loadBsConfig = (. ~config as _) => Ok(BsConfig.TestData.make(~bscFlags=["-open Belt"]))
  let loadSourceDirs = (. ~config as _) => t->Assert.fail("Shouldn't call loadSourceDirs")
  let lint = Lint.make(~loadBsConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(. ~config=Config.make(~projectPath="", ~ignoreWithoutStdlibOpen=false)),
    Error(BsConfigHasOpenedProhibitedModule(ModuleName.TestData.make("Belt"))),
    (),
  )
})

test("Fails when can't parse sourcedirs.json", t => {
  let loadBsConfig = (. ~config as _) => Ok(BsConfig.TestData.make(~bscFlags=[]))
  let loadSourceDirs = (. ~config as _) => Error(Port.LoadSourceDirs.ParsingFailure("Some reason"))
  let lint = Lint.make(~loadBsConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(. ~config=Config.make(~projectPath="", ~ignoreWithoutStdlibOpen=false)),
    Error(SourceDirsParseFailure("Some reason")),
    (),
  )
})

test("Fails when can't find rescript artifacts", t => {
  let loadBsConfig = (. ~config as _) => Ok(BsConfig.TestData.make(~bscFlags=[]))
  let loadSourceDirs = (. ~config as _) => Error(
    Port.LoadSourceDirs.RescriptCompilerArtifactsNotFound,
  )
  let lint = Lint.make(~loadBsConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(. ~config=Config.make(~projectPath="", ~ignoreWithoutStdlibOpen=false)),
    Error(RescriptCompilerArtifactsNotFound),
    (),
  )
})

test("Doesn't complain with valid project", t => {
  let loadBsConfig = (. ~config as _) => Ok(BsConfig.TestData.make(~bscFlags=[]))
  let loadSourceDirs = (. ~config as _) => Ok(SourceDirs.TestData.make(~projectDirs=["src"]))
  let lint = Lint.make(~loadBsConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(. ~config=Config.make(~projectPath="fixtures/Lint/valid", ~ignoreWithoutStdlibOpen=false)),
    Ok(),
    (),
  )
})

test("Doesn't complain with invalid ReScript files not specified in projectDirs", t => {
  let loadBsConfig = (. ~config as _) => Ok(BsConfig.TestData.make(~bscFlags=[]))
  let loadSourceDirs = (. ~config as _) => Ok(SourceDirs.TestData.make(~projectDirs=["src"]))
  let lint = Lint.make(~loadBsConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(.
      ~config=Config.make(
        ~projectPath="fixtures/Lint/invalidNotProject",
        ~ignoreWithoutStdlibOpen=false,
      ),
    ),
    Ok(),
    (),
  )
})

test("Complains with invalid project", t => {
  let loadBsConfig = (. ~config as _) => Ok(BsConfig.TestData.make(~bscFlags=[]))
  let loadSourceDirs = (. ~config as _) => Ok(SourceDirs.TestData.make(~projectDirs=["src"]))
  let lint = Lint.make(~loadBsConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(.
      ~config=Config.make(~projectPath="fixtures/Lint/invalid", ~ignoreWithoutStdlibOpen=false),
    ),
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
