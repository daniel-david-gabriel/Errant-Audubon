KeyBindings = {}
KeyBindings.__index = KeyBindings


setmetatable(KeyBindings, {
  __index = KeyBindings,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function KeyBindings:_init()
	self.bindingsFilename = "bindings.dat"
	self.bindings = {}

	--Prepopulate bindings with defaults in case of incomplete bindings file
	self.bindings["quit"] = "escape"
	self.bindings["up"] = "up"
	self.bindings["down"] = "down"
	self.bindings["left"] = "left"
	self.bindings["right"] = "right"
	self.bindings["menu"] = "return"
	self.bindings["tool"] = "x"
	self.bindings["subtool"] = "z"
	self.bindings["shift"] = "lshift"
	self.bindings["space"] = "lctrl"

	if love.filesystem.getInfo(self.bindingsFilename) then
		self:loadBindings()
	end
end

function KeyBindings.getQuit(self)
	return self.bindings["quit"]
end

function KeyBindings.getUp(self)
	return self.bindings["up"]
end

function KeyBindings.getDown(self)
	return self.bindings["down"]
end

function KeyBindings.getLeft(self)
	return self.bindings["left"]
end

function KeyBindings.getRight(self)
	return self.bindings["right"]
end

function KeyBindings.getMenu(self)
	return self.bindings["menu"]
end

function KeyBindings.getSubtool(self)
	return self.bindings["subtool"]
end

function KeyBindings.getTool(self)
	return self.bindings["tool"]
end

function KeyBindings.getShift(self)
	return self.bindings["shift"]
end

function KeyBindings.getSpace(self)
	return self.bindings["space"]
end


function KeyBindings.loadBindings(self)
	local bindingsFileLines = love.filesystem.lines(self.bindingsFilename)

	for line in bindingsFileLines do
		local lineTokens = split(line, "%S+")
		--inspect first token for valid value?

		if lineTokens[2] == "(space)" then
			lineTokens[2] = " "
		end

		self.bindings[lineTokens[1]] = lineTokens[2]
	end
end

function KeyBindings.saveBindings(self)
	local savedBindings = ""
	for k,v in pairs(self.bindings) do
		if v == " " then
			v = "(space)"
		end
		savedBindings = savedBindings .. k .. " " .. v .. "\r\n"
	end

	love.filesystem.write(self.bindingsFilename, savedBindings)
end








