let make = () => {
  (. ()) => {
    let jsonObj = {
      open NodeJs
      Fs.readFileSyncWith(
        Path.resolve([Process.process->Process.cwd, "bsconfig.json"]),
        Fs.readFileOptions(~encoding="utf8", ()),
      )
      ->Buffer.toString
      ->Json.parseExn
    }
    jsonObj
    ->S.parseWith(BsConfig.struct)
    ->Result.mapError((. error) => {
      Port.LoadBsConfig.ParsingFailure(error->S.Error.toString)
    })
  }
}
