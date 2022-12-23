let make = () => {
  (. ~config) => {
    {
      open NodeJs
      Fs.readFileSyncWith(
        Path.resolve([config->Config.getProjectPath, "bsconfig.json"]),
        Fs.readFileOptions(~encoding="utf8", ()),
      )->Buffer.toString
    }
    ->BsConfig.fromJsonString
    ->Result.mapError(error => {
      Port.LoadBsConfig.ParsingFailure(error)
    })
  }
}
