let make = () => {
  (. ()) => {
    try {
      open NodeJs
      Fs.readFileSyncWith(
        Path.resolve([Process.process->Process.cwd, "lib/bs/.sourcedirs.json"]),
        Fs.readFileOptions(~encoding="utf8", ()),
      )
      ->Buffer.toString
      ->Ok
    } catch {
    // TODO: Try to build rescript ourselves
    | _ => Error(Ports.LoadSourceDirs.RescriptCompilerArtifactsNotFound)
    }->Result.flatMap((. file) =>
      file
      ->Json.parseExn
      ->S.parseWith(SourceDirs.struct)
      ->Result.mapError((. error): Ports.LoadSourceDirs.error => {
        ParsingFailure(error->S.Error.toString)
      })
    )
  }
}
