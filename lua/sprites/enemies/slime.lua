require("lua/sprites/enemy")

Slime = {}
Slime.__index = Slime


setmetatable(Slime, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Slime:_init(x, y)
	Enemy._init(self, x, y, 32, 32, "small", 1, "slimeball", "eye", "diamond")

	self.moveTimer = 0
	self.spriteCounter = 1

	self.speed = 8
	self.direction = "down"
	self.sprites = images:getImage("slime")
	self.name = "slime"
end

function Slime.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	if self.direction == "down" then
		love.graphics.draw(self.sprites["front"][self.spriteCounter], (self.x)-32, (self.y)-32)
	elseif self.direction == "up" then
		love.graphics.draw(self.sprites["back"][self.spriteCounter], (self.x)-32, (self.y)-32)
	end
end

function Slime.update(self, map, dt)
	if knight.isGrabbing and knight.grabbedEnemy == self then
		self.x = knight.x - 16
		self.y = knight.y - 16

		self.spriteCounter = 1
		return
	end

	if self:collidesWith(knight) then
		knight:knockback(self, 5)
	end

	if not self:isInRange(knight) then
		return
	end

	self.moveTimer = self.moveTimer + dt
	if self.moveTimer < 0.25 then
		return
	end
	self.moveTimer = 0
	self.spriteCounter = self.spriteCounter + 1
	if self.spriteCounter > 2 then
		self.spriteCounter = 1
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

function Slime.isInRange(self, enemy)
	local xWithinRange = math.abs(self.x - enemy.x) < 100
	local yWithinRange = math.abs(self.y - enemy.y) < 100

	return (xWithinRange and yWithinRange)
end
