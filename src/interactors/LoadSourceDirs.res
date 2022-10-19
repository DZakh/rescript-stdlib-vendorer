let make = () => {
  (. ()) => {
    let jsonObj = {
      open NodeJs
      // TODO: When missing ask to build rescript or do it yourself
      Fs.readFileSyncWith(
        Path.resolve([Process.process->Process.cwd, "lib/bs/.sourcedirs.json"]),
        Fs.readFileOptions(~encoding="utf8", ()),
      )
      ->Buffer.toString
      ->Js.Json.parseExn
    }
    jsonObj
    ->S.parseWith(SourceDirs.struct)
    ->Lib.Result.mapError((. error) => {
      #PARSING_FAILURE(error->S.Error.toString)
    })
  }
}
