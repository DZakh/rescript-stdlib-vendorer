module type String = {
  type t
  external unsafeFromString: string => t = "%identity"
  external toString: t => string = "%identity"
}
module String = {
  type t = string
  external unsafeFromString: string => t = "%identity"
  external toString: t => string = "%identity"
}
