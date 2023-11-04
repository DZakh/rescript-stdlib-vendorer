let make = () => {
  (~config) => {
    {
      open NodeJs

      try {
        Fs.readFileSyncWith(
          Path.resolve([config->Config.getProjectPath, "bsconfig.json"]),
          Fs.readFileOptions(~encoding="utf8", ()),
        )->Buffer.toString
      } catch {
      | Exn.Error(err) if (err->Obj.magic)["code"] === "ENOENT" =>
        Fs.readFileSyncWith(
          Path.resolve([config->Config.getProjectPath, "rescript.json"]),
          Fs.readFileOptions(~encoding="utf8", ()),
        )->Buffer.toString
      }
    }
    ->ResConfig.fromJsonString
    ->Result.mapError(error => {
      Port.LoadResConfig.ParsingFailure(error)
    })
  }
}
