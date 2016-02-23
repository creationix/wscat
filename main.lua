
dofile("luvit-loader.lua")
local connect = require('websocket-client')
local readLine = require('readline').readLine
local split = require('coro-split')


local url = assert(args[1], "The first argument should be the wss:// url")
local subprotocol = args[2]

local function getLine()
  local thread = coroutine.running()
  readLine("", function (err, line)
    assert(coroutine.resume(thread, line, err))
  end)
  return coroutine.yield()
end


coroutine.wrap(function ()
  local read, write = assert(connect(url, subprotocol, {}))
  split(function ()
    for line in getLine do
      write {
        opcode = 1,
        payload = line
      }
    end
  end, function ()
    for message in read do
      if message.opcode == 1 then
        print(message.payload)
      end
    end
  end)
  write()

end)()

require('uv').run()
