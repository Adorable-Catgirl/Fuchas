local lib = {}
local cursor = {
	x = 1,
	y = 1
}

function lib.getX()
	return cursor.x
end

function lib.getY()
	return cursor.y
end

function lib.setY(y)
	cursor.y = y
end

function lib.setX(x)
	cursor.x = x
end

function lib.getCursor()
	return cursor.x, cursor.y
end

function lib.setCursor(col, row)
	cursor.x = col
	cursor.y = row
end

function lib.clear()
	require("OCX/ConsoleUI").clear(0x000000)
	lib.setCursor(1, 1)
end

function lib.getKeyboard()
	return component.getPrimary("screen").getKeyboards()[0]
end

function lib.getScreen()
	return component.getPrimary("screen").address
end

function lib.parse(tab)
	local ntab = {}
	local options = {}
	for _, v in pairs(tab) do
		if v:len() > 0 then
			if v:sub(1, 2) == "--" then
				options[v:sub(3, v:len())] = true
			elseif v:sub(1, 1) == "-" then
				options[v:sub(2, 2)] = true
			else
				table.insert(ntab, v)
			end
		end
	end
	return ntab, options
end

function lib.resolve(path)
	return path
end

function lib.write(obj)
	write(tostring(obj))
end

function lib.parseCL(cl)
	local args = {}
	local ca = string.toCharArray(cl)
	
	local istr = false
	local arg = ""
	for i = 1, #ca do
		local c = ca[i]
		if not istr then
			if c == '"' then
				arg = ""
				istr = true
			elseif c == " " then
				table.insert(args, arg)
				arg = ""
			else
				arg = arg .. c
			end
		else
			if c == '"' then
				istr = false
				table.insert(args, arg)
				arg = ""
			else
				arg = arg .. c
			end
		end
	end
	if arg ~= "" then
		if istr then
			error("parse error: long-argument not ended with \"")
		end
		table.insert(args, arg)
	end
	
	return args
end

function lib.read()
	local c = ""
	local s = ""
	local event = require("event")
	while c ~= '\r' do -- '\r' == Enter
		local a, b, d = event.pull("key_down")
		if a == "key_down" then
			if d ~= 0 then
				c = string.char(d)
				if c ~= '\r' then
					if d == 8 then -- backspace
						if s:len() > 0 then
							s = s:sub(1, s:len() - 1)
							cursor.x = cursor.x - 1
							write(" ")
							cursor.x = cursor.x - 1
						end
					else
						s = s .. c
						write(c)
					end
				end
			end
		end
	end
	return s
end

return lib