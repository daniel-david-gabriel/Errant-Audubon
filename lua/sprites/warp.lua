require("lua/sprites/sprite")

Warp = {}
Warp.__index = Warp


setmetatable(Warp, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Warp:_init(x, y, toMap, toXPos, toYPos)
	Sprite._init(self, x, y, 32, 16)
	self.toMap = toMap
	self.toXPos = toXPos
	self.toYPos = toYPos
end

function Warp.draw(self)
	if options.debug then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	end
end

function Warp.update(self, dt)
	if self:collidesWith(knight) then
		toMap = maps[self.toMap]
		knight.x = self.toXPos * 32
		knight.y = self.toYPos * 32
	end
end
