VERSION = "1.0.0"

local micro = import("micro")
local config = import("micro/config")
local shell = import("micro/shell")
local runtime = import("runtime")

function init()
	config.MakeCommand("urlopen", urlopen, config.NoComplete)
	config.TryBindKey("Alt-o", "command:urlopen", true)
end

function urlopen(bp)
	local c = bp.Cursor
	local buf = bp.Buf
	local line = buf:Line(c.Y)

	local start, stop = string.find(line, "https?://[-%()_.!~*';/?:@&=+$,A-Za-z0-9]+")
	if start then
		local result = string.sub(line,start,stop)
		if (c.X >= start - 1) and (c.X <= stop - 1) then
		    local goos = runtime["GOOS"]
		    local cmd = ""
		    if goos == "darwin" then
                cmd = "open "
            elseif goos == "linux" then
                cmd = "xdg-open "
            elseif goos == "windows" then
                cmd = "start "
            end
		    shell.RunCommand(cmd..result)
		else
			micro.InfoBar():Message("Not a link")
		end
	else
		micro.InfoBar():Message("Not a link")
	end
end
