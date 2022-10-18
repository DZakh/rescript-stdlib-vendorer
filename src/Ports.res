type runLintCommand = (
  . unit,
) => result<
  unit,
  [
    | #BS_CONFIG_PARSE_FAILURE(string)
    | #SOURCE_DIRS_PARSE_FAILURE(string)
    | #HAS_GLOBALY_OPENED_STDLIB(string)
  ],
>

type runLintHelpCommand = (. unit) => unit

type runHelpCommand = (. unit) => unit

type loadBsConfig = (. unit) => result<BsConfig.t, [#PARSING_FAILURE(string)]>

type loadSourceDirs = (. unit) => result<SourceDirs.t, [#PARSING_FAILURE(string)]>

type runCli = (. unit) => unit
