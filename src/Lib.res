module Result = {
  let mapError = (result, fn) => {
    switch result {
    | Ok(_) as ok => ok
    | Error(error) => Error(fn(. error))
    }
  }
}

module Array = {
  @send
  external flatMap: (array<'a>, 'a => array<'b>) => array<'b> = "flatMap"
}
