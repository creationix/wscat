local bundle = require('luvi').bundle
loadstring(bundle.readfile("luvit-loader.lua"), "bundle:luvit-loader.lua")()

local uv = require('uv')
local parseUrl = require('coro-websocket').parseUrl
local connect = require('coro-websocket').connect
local readline = require('readline')
local History = readline.History
local Editor = readline.Editor
local split = require('coro-split')
local pp = require('pretty-print')
local p = pp.prettyPrint
local meta = require('./package')

local options, url
do
  local args = {...}
  url = args[1]
  if not url then
    print(string.format("%s v%s", meta.name, meta.version))
    print("usage: wscat url [subprotocol]")
    print("example: wscat wss://lit.luvit.io/ lit")
    return 1
  end
  local err
  options, err = parseUrl(url)
  if err then
    print(err)
    return -1
  end
  if options.pathname == "" then
    options.pathname = "/"
  end
  options.subprotocol = args[2]
end

local getLine
do
  local thread, editor
  local prompt = ""
  local history = History.new()
  editor = Editor.new({
    stdin = pp.stdin,
    stdout = pp.stdout,
    history = history
  })

  local function onLine(err, line, reason)
    local t = thread
    thread = nil
    return assert(coroutine.resume(t, line, err or reason))
  end

  function getLine()
    thread = coroutine.running()
    editor:readLine(prompt, onLine)
    return coroutine.yield()
  end
end


coroutine.wrap(function ()
  local connectMessage = "Conecting to " .. url
  if options.subprotocol then
    connectMessage = connectMessage .. " using " .. options.subprotocol
  end
  print(connectMessage)
  local res, read, write = assert(connect(options))
  local peer = res.socket:getpeername()
  res.socket:keepalive(true, 1000)

  print(string.format("Connected to %s:%s", peer.ip, peer.port))
  print("(Use Control+D to send EOF)")

  local done = false
  local function getInput()
    for line in getLine do
      assert(write {
        opcode = 1,
        payload = line
      })
    end
    write()
    done = true
  end

  local function logMessages()
    for message in read do
      if message.opcode == 1 then -- text
        print(message.payload)
      elseif message.opcode == 2 then -- binary
        p(message.payload)
      end
    end
    if not done then
      print("Server disconnected")
      os.exit(-1)
    end
  end

  split(getInput, logMessages)

end)()

uv.run()
