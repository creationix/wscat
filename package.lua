return {
  name = "creationix/wscat",
  version = "0.1.1",
  description = "A netcat like client for websockets",
  luvi = {
    version = "2.6.1",
    flavor = "tiny",
  },
  homepage = "https://github.com/creationix/wscat",
  dependencies = {
    "creationix/websocket-client",
    "luvit/readline",
    "creationix/coro-split",
    "luvit/pretty-print",
  }
}
