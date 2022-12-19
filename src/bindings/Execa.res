type returnValue = {stdout: string}
type options = {env?: Dict.t<string>}

@module("execa")
external execa: (string, array<string>, ~options: options=?, unit) => promise<returnValue> = "execa"
