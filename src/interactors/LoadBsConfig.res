let make = (~projectPath) => {
  (. ()) => {
    {
      open NodeJs
      Fs.readFileSyncWith(
        Path.resolve([projectPath, "bsconfig.json"]),
        Fs.readFileOptions(~encoding="utf8", ()),
      )->Buffer.toString
    }
    ->BsConfig.fromJsonString
    ->Result.mapError((. error) => {
      Port.LoadBsConfig.ParsingFailure(error)
    })
  }
}
