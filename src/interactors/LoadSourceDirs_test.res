open Ava

test("Loads sourceDirs with project directories", t => {
  let loadSourceDirs = LoadSourceDirs.make()

  t->Assert.deepEqual(
    loadSourceDirs(.
      ~config=Config.make(
        ~projectPath="fixtures/LoadSourceDirs/withProjectDirs",
        ~ignoreWithoutStdlibOpen=false,
        ~ignorePaths=[],
      ),
    ),
    Ok(
      SourceDirs.TestData.make(
        ~projectDirs=["src", "src/entities", "src/interactors", "src/bindings"],
      ),
    ),
    (),
  )
})

test("Returns error when sourcedirs.json is invalid", t => {
  let loadSourceDirs = LoadSourceDirs.make()

  t->Assert.deepEqual(
    loadSourceDirs(.
      ~config=Config.make(
        ~projectPath="fixtures/LoadSourceDirs/withInvalidSourcedirs",
        ~ignoreWithoutStdlibOpen=false,
        ~ignorePaths=[],
      ),
    ),
    Error(ParsingFailure("Failed parsing at [dirs]. Reason: Expected Array, received Option")),
    (),
  )
})

test("Returns error sourcedirs.json is missing", t => {
  let loadSourceDirs = LoadSourceDirs.make()

  t->Assert.deepEqual(
    loadSourceDirs(.
      ~config=Config.make(
        ~projectPath="fixtures/LoadSourceDirs/withoutBsconfig",
        ~ignoreWithoutStdlibOpen=false,
        ~ignorePaths=[],
      ),
    ),
    Error(RescriptCompilerArtifactsNotFound),
    (),
  )
})
