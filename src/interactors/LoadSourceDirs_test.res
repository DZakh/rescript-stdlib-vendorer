open Ava

test("Loads sourceDirs with project directories", t => {
  let loadSourceDirs = LoadSourceDirs.make(~projectPath="fixtures/LoadSourceDirs/withProjectDirs")

  t->Assert.deepEqual(
    loadSourceDirs(.),
    Ok(
      SourceDirs.TestData.make(
        ~projectDirs=["src", "src/entities", "src/interactors", "src/bindings"],
      ),
    ),
    (),
  )
})

test("Returns error when sourcedirs.json is invalid", t => {
  let loadSourceDirs = LoadSourceDirs.make(
    ~projectPath="fixtures/LoadSourceDirs/withInvalidSourcedirs",
  )

  t->Assert.deepEqual(
    loadSourceDirs(.),
    Error(ParsingFailure("Failed parsing at [dirs]. Reason: Expected Array, received Option")),
    (),
  )
})

test("Returns error sourcedirs.json is missing", t => {
  let loadSourceDirs = LoadSourceDirs.make(~projectPath="fixtures/LoadSourceDirs/withoutBsconfig")

  t->Assert.deepEqual(loadSourceDirs(.), Error(RescriptCompilerArtifactsNotFound), ())
})
