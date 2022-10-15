type runLintCommand = (
  . unit,
) => result<
  unit,
  [
    | #BS_CONFIG_LOAD_FAILURE
    | #BS_CONFIG_PARSE_FAILURE(string)
    | #HAS_GLOBALY_OPENED_STDLIB(string)
  ],
>

type runLintHelpCommand = (. unit) => unit

type runHelpCommand = (. unit) => unit

type loadBsConfig = (. unit) => result<BsConfig.t, [#LOAD_FAILURE | #PARSING_FAILURE(string)]>

type runCli = (. unit) => unit
