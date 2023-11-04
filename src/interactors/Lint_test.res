open Ava

test("Fails when can't parse bsconfig", t => {
  let loadResConfig = (~config as _) => Error(Port.LoadResConfig.ParsingFailure("Some reason"))
  let loadSourceDirs = (~config as _) => t->Assert.fail("Shouldn't call loadSourceDirs")
  let lint = Lint.make(~loadResConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(~config=Config.make(~projectPath="", ~ignoreWithoutStdlibOpen=false, ~ignorePaths=[])),
    Error(ResConfigParseFailure("Some reason")),
    (),
  )
})

test("Fails with globally opened prohibited module", t => {
  let loadResConfig = (~config as _) => Ok(ResConfig.TestData.make(~bscFlags=["-open Belt"]))
  let loadSourceDirs = (~config as _) => t->Assert.fail("Shouldn't call loadSourceDirs")
  let lint = Lint.make(~loadResConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(~config=Config.make(~projectPath="", ~ignoreWithoutStdlibOpen=false, ~ignorePaths=[])),
    Error(ResConfigHasOpenedProhibitedModule(ModuleName.TestData.make("Belt"))),
    (),
  )
})

test("Fails when can't parse sourcedirs.json", t => {
  let loadResConfig = (~config as _) => Ok(ResConfig.TestData.make(~bscFlags=[]))
  let loadSourceDirs = (~config as _) => Error(Port.LoadSourceDirs.ParsingFailure("Some reason"))
  let lint = Lint.make(~loadResConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(~config=Config.make(~projectPath="", ~ignoreWithoutStdlibOpen=false, ~ignorePaths=[])),
    Error(SourceDirsParseFailure("Some reason")),
    (),
  )
})

test("Fails when can't find rescript artifacts", t => {
  let loadResConfig = (~config as _) => Ok(ResConfig.TestData.make(~bscFlags=[]))
  let loadSourceDirs = (~config as _) => Error(
    Port.LoadSourceDirs.RescriptCompilerArtifactsNotFound,
  )
  let lint = Lint.make(~loadResConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(~config=Config.make(~projectPath="", ~ignoreWithoutStdlibOpen=false, ~ignorePaths=[])),
    Error(RescriptCompilerArtifactsNotFound),
    (),
  )
})

test("Doesn't complain with valid project", t => {
  let loadResConfig = (~config as _) => Ok(ResConfig.TestData.make(~bscFlags=[]))
  let loadSourceDirs = (~config as _) => Ok(SourceDirs.TestData.make(~projectDirs=["src"]))
  let lint = Lint.make(~loadResConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(
      ~config=Config.make(
        ~projectPath="fixtures/Lint/valid",
        ~ignoreWithoutStdlibOpen=false,
        ~ignorePaths=[],
      ),
    ),
    Ok(),
    (),
  )
})

test("Doesn't complain with invalid ReScript files not specified in projectDirs", t => {
  let loadResConfig = (~config as _) => Ok(ResConfig.TestData.make(~bscFlags=[]))
  let loadSourceDirs = (~config as _) => Ok(SourceDirs.TestData.make(~projectDirs=["src"]))
  let lint = Lint.make(~loadResConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(
      ~config=Config.make(
        ~projectPath="fixtures/Lint/invalidNotProject",
        ~ignoreWithoutStdlibOpen=false,
        ~ignorePaths=[],
      ),
    ),
    Ok(),
    (),
  )
})

test("Complains with invalid project", t => {
  let loadResConfig = (~config as _) => Ok(ResConfig.TestData.make(~bscFlags=[]))
  let loadSourceDirs = (~config as _) => Ok(SourceDirs.TestData.make(~projectDirs=["src"]))
  let lint = Lint.make(~loadResConfig, ~loadSourceDirs)

  t->Assert.deepEqual(
    lint(
      ~config=Config.make(
        ~projectPath="fixtures/Lint/invalid",
        ~ignoreWithoutStdlibOpen=false,
        ~ignorePaths=[],
      ),
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
