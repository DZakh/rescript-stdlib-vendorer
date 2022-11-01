let flatMap = Belt.Result.flatMapU

let map = Belt.Result.mapU

let mapError = (result, fn) => {
  switch result {
  | Ok(_) as ok => ok
  | Error(error) => Error(fn(. error))
  }
}
