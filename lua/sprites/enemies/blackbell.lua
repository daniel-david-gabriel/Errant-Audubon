require("lua/sprites/enemy")

BlackBell = {}
BlackBell.__index = BlackBell


setmetatable(BlackBell, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function BlackBell:_init(x, y)
	Enemy._init(self, x, y, 32, 32)

	self.speed = 1
	self.direction = "down"
	self.sprites = images:getImage("blackbell")
	self.name = "blackbell"
end

function BlackBell.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	if self.direction == "down" then
		love.graphics.draw(self.sprites["front"][1], (self.x)-32, (self.y)-32)
	elseif self.direction == "up" then
		love.graphics.draw(self.sprites["back"][1], (self.x)-32, (self.y)-32)
	end
end

function BlackBell.update(self, map, dt)
	if self:collidesWith(knight) then
		knight:damage(10)
		knight:knockback(self)
	end

	if self:isLeftOf(knight) then
		self:move("right", self.speed)
	elseif self:isRightOf(knight) then
		self:move("left", self.speed)
	elseif self:isAbove(knight) then
		self:move("down", self.speed)
		self.direction = "down"
	elseif self:isBelow(knight) then
		self:move("up", self.speed)
		self.direction = "up"
	end
end
