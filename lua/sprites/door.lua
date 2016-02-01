require("lua/sprites/sprite")

Door = {}
Door.__index = Door


setmetatable(Door, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Door:_init(x, y, toMap, toXPos, toYPos)
	Sprite._init(self, x, y, 32, 32)
	self.toMap = toMap
	self.toXPos = toXPos
	self.toYPos = toYPos
end

function Door.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("fill", (self.xPos*32)-32, (self.yPos*32)-32, 32, 32)
end

function Door.update(self, dt)
	if self:collidesWith(knight) then
		toMap = maps[self.toMap]

		knight.xPos = self.toXPos
		knight.yPos = self.toYPos

		knight.x = self.toXPos * 32
		knight.y = self.toYPos * 32
	end
end
