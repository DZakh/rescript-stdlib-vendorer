let make = () => {
  (. ()) => {
    try {
      open NodeJs
      Fs.readFileSyncWith(
        Path.resolve([Process.process->Process.cwd, "bsconfig.json"]),
        Fs.readFileOptions(~encoding="utf8", ()),
      )
      ->Buffer.toString
      ->Js.Json.parseExn
      ->Ok
    } catch {
    | _ => Error(#LOAD_FAILURE)
    }->Belt.Result.flatMap(jsonObj => {
      let sourceStruct = S.union([
        S.string()->S.transform(~parser=dir => BsConfig.Source.make(~dir, ~subdirs=Without), ()),
        S.object2(.
          ("dir", S.string()),
          ("subdirs", S.option(S.union([S.bool()->S.transform(~parser=bool => {
                  switch bool {
                  | true => BsConfig.Source.Recursive
                  | false => BsConfig.Source.Without
                  }
                }, ()), S.array(
                  S.string(),
                )->S.transform(
                  ~parser=specific => BsConfig.Source.Specific(specific),
                  (),
                )]))->S.defaulted(Without)),
        )
        ->S.transform(~parser=((dir, subdirs)) => BsConfig.Source.make(~dir, ~subdirs), ())
        ->S.Object.strict,
      ])
      let struct =
        S.object2(.
          ("bsc-flags", S.option(S.array(S.string()))->S.defaulted([])),
          (
            "sources",
            S.union([
              sourceStruct->S.transform(~parser=source => [source], ()),
              S.array(sourceStruct),
            ]),
          ),
        )->S.transform(~parser=((bscFlags, sources)) => BsConfig.make(~bscFlags, ~sources), ())

      jsonObj
      ->S.parseWith(struct)
      ->Lib.Result.mapError((. error) => {
        #PARSING_FAILURE(error->S.Error.toString)
      })
    })
  }
}
