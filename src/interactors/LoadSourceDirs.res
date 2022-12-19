let make = (~projectPath) => {
  (. ()) => {
    try {
      open NodeJs
      Fs.readFileSyncWith(
        Path.resolve([projectPath, "lib/bs/.sourcedirs.json"]),
        Fs.readFileOptions(~encoding="utf8", ()),
      )
      ->Buffer.toString
      ->Ok
    } catch {
    // TODO: Try to build rescript ourselves
    | _ => Error(Port.LoadSourceDirs.RescriptCompilerArtifactsNotFound)
    }->Result.flatMap((. file) =>
      file
      ->SourceDirs.fromJsonString
      ->Result.mapError((. error): Port.LoadSourceDirs.error => {
        ParsingFailure(error)
      })
    )
  }
}
