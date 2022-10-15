module Result = {
  let mapError = (result, fn) => {
    switch result {
    | Ok(_) as ok => ok
    | Error(error) => Error(fn(. error))
    }
  }
}
