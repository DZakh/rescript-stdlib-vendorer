let make = () => {
  (. ()) => {
    let jsonObj = {
      open NodeJs
      Fs.readFileSyncWith(
        Path.resolve([Process.process->Process.cwd, "bsconfig.json"]),
        Fs.readFileOptions(~encoding="utf8", ()),
      )
      ->Buffer.toString
      ->Js.Json.parseExn
    }
    jsonObj
    ->S.parseWith(BsConfig.struct)
    ->Lib.Result.mapError((. error) => {
      #PARSING_FAILURE(error->S.Error.toString)
    })
  }
}
