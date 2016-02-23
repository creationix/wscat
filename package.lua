return {
  name = "creationix/wscat",
  version = "0.1.0",
  description = "A netcat like client for websockets",
  luvi = {
    version = "2.6.1",
    flavor = "tiny",
  },
  dependencies = {
    "creationix/websocket-client",
    "luvit/readline",
    "creationix/coro-split",
    "luvit/pretty-print",
  }
}
