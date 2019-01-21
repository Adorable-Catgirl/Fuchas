-- Bootstrap for Fuchas interface.

local c = require("OCX/ConsoleUI")
local fs = require("filesystem")
local drv = require("driver")
c.clear(0x000000)

-- Bootstrap routine
_G.shin32 = require("shin32")
dofile("Fuchas/autorun.lua") -- system variables autorun

local function httpDownload(url, dest)
	local h = component.getPrimary("internet").request(url)
	h:finishConnect()
	local file = require("filesystem").open(dest, "w")
	local data = ""
	while data ~= nil do
		file:write(tostring(h:read()))
	end
	file:close()
	h:close()
end

if fs.exists("/installing") then
	c.clear(0xAAAAAA)
	p = c.progressBar(100)
	pu.background = 0xAAAAAA
	p.background = 0xAAAAAA
	p.progress = 20
	p.x = 55
	p.y = 45
	p.width = 50
	p.height = 2
	pu.text = "Installing Shindows.."
	pu.y = 40
	local det = c.label("Loading network driver..")
	det.x = 68
	det.background = 0xAAAAAA
	det.y = 42
	det.render()
	pu.render()
	p.dirty = true
	p.render()
	if drv.isDriverAvailable("internet") or true then
		drv.changeDriver("internet", "internet")
		local int = drv.getDriver("internet")
		httpDownload("https://raw.githubusercontent.com/zenith391/Shindows_OC/master/Fuchas/Libraries/filesystem.lua", "/test.lua")
	end
	print(tostring(drv.isDriverAvailable("internet")))
	return
end
y = 1
shin32.newProcess("System", function()
	local f, err = xpcall(function()
		local l, err = loadfile("/Fuchas/DOE/sh.lua")
		if l == nil then
			error(err)
		end
		c.clear(0xFFFFFF)
		os.sleep(.1)
		c.clear(0xAAAAAA)
		os.sleep(.1)
		c.clear(0x2D2D2D)
		os.sleep(.1)
		c.clear(0x000000)
		os.sleep(.1)
		return l()
	end, function(err)
		print(err)
		print(debug.traceback(" ", 1))
	end)
	if f == false then
		print("Error:", 0xFF0000)
		print(err, 0xFF0000)
	else
		computer.shutdown() -- main interface exit
	end
end)

while true do
	shin32.scheduler()
end