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
	self.bindings["up"] = "w"
	self.bindings["down"] = "s"
	self.bindings["left"] = "a"
	self.bindings["right"] = "d"
	self.bindings["menu"] = "return"
	self.bindings["tool"] = "space"
	self.bindings["subtool"] = "lshift"

	if love.filesystem.exists(self.bindingsFilename) then
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

function KeyBindings.loadBindings(self)
	local bindingsFileLines = love.filesystem.lines(self.bindingsFilename)

	for line in bindingsFileLines do
		local lineTokens = split(line, "%S+")
		--inspect first token for valid value?

		self.bindings[lineTokens[1]] = lineTokens[2]
	end
end

function KeyBindings.saveBindings(self)
	local savedBindings = ""
	for k,v in pairs(self.bindings) do
		savedBindings = savedBindings .. k .. " " .. v .. "\r\n"
	end

	love.filesystem.write(self.bindingsFilename, savedBindings)
end








