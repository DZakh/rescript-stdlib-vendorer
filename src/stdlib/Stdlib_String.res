include Js.String2

@send
external replaceAllByRe: (string, Js.Re.t, string) => string = "replaceAll"
