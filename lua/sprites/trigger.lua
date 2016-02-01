require("lua/sprites/sprite")

Trigger = {}
Trigger.__index = Trigger


setmetatable(Trigger, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Trigger:_init(x, y, flag, value)
	Sprite._init(self, x, y, 32, 32)
	self.flag = flag
	self.value = value
end

function Trigger.draw(self)
	--[[if options.debug then
		love.graphics.setColor(128, 255, 255, 255)
		love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	end--]]
	
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(images:getImage("circle"), self.x-32, self.y-32)
end

function Trigger.update(self, dt)
	if self:collidesWith(knight) then
		if knight.flags[self.flag] < self.value then
			knight.flags[self.flag] = self.value
		end
	end
end
