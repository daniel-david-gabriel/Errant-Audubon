require("lua/sprites/sprite")

Npc = {}
Npc.__index = Npc


setmetatable(Npc, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Npc:_init(x, y, width, height, name, portraitName, flag, dialog)
	Sprite._init(self, x, y, width, height)

	self.flag = flag
	self.dialog = dialog
	self.portraitName = portraitName
	self.name = name
	--self.spriteName = spritename
end

function Npc.draw(self)
	love.graphics.setColor(0, 0, 255, 255)
	love.graphics.rectangle("fill", (self.x)-32, (self.y)-32, 32, 32)
end

function Npc.interact(self)
	local flagValue = knight.flags[self.flag]

	if not self.dialog[flagValue] then
		flagValue = 1
	end

	game.dialog:set(self.name, self.portraitName, self.dialog[flagValue])
end
