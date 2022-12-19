module type String = {
  type t
  external toString: t => string = "%identity"
}
module String = {
  type t = string
  external toString: t => string = "%identity"
}
