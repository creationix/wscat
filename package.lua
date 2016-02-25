return {
  name = "creationix/wscat",
  version = "0.2.0",
  description = "A netcat like client for websockets",
  luvi = {
    version = "2.6.1",
    flavor = "regular",
  },
  homepage = "https://github.com/creationix/wscat",
  dependencies = {
    "luvit/pretty-print@2.0.0",
    "luvit/readline@2.0.0",
    "luvit/secure-socket@1.0.0",
    "creationix/coro-split@2.0.0",
    "creationix/coro-websocket@1.0.0",
  },
  files = {
    "*.lua",
  }
}
