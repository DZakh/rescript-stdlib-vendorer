type returnValue = {stdout: string}

@module("execa")
external execa: (string, array<string>) => promise<returnValue> = "execa"
