module Result = {
  let flatMap = (result, fn) => Belt.Result.flatMapU(result, fn)

  let mapError = (result, fn) => {
    switch result {
    | Ok(_) as ok => ok
    | Error(error) => Error(fn(. error))
    }
  }
}

module Array = {
  include Js.Array2

  @send
  external flatMap: (array<'a>, 'a => array<'b>) => array<'b> = "flatMap"
}

module String = Js.String2
module Option = Belt.Option
module Exn = Js.Exn
module Json = Js.Json
module Re = Js.Re
module Int = Js.Int
