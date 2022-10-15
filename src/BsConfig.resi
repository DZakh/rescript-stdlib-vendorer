module Source: {
  type subdirs = Recursive | Without | Specific(array<string>)
  type t

  let make: (~dir: string, ~subdirs: subdirs) => t
}

type t

let make: (~sources: array<Source.t>, ~bscFlags: array<string>) => t

let globalyOpenedModules: t => array<string>
