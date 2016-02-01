require("lua/sprites/enemy")

PotSpider = {}
PotSpider.__index = PotSpider


setmetatable(PotSpider, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function PotSpider:_init(x, y)
	Enemy._init(self, x, y, 32, 32, "small", 3, "claw", "eye", "tuft")

	self.moveTimer = 0
	self.spriteCounter = 1
	self.speed = 12

	self.state = "sleep"
	self.waitingTimer = 0
	self.direction  = "down"

	self.spriteName = "potSpider"
	self.name = "potSpider"
end

function PotSpider.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	local sprites = images:getImage(self.spriteName)
	if self.state == "sleep" then
		love.graphics.drawq(sprites["image"], sprites["quads"]["sleep"..self.direction][1], (self.x)-32, (self.y)-64)
	elseif self.state == "stand" then
		love.graphics.drawq(sprites["image"], sprites["quads"]["stand"..self.direction][1], (self.x)-32, (self.y)-64)
	else
		love.graphics.drawq(sprites["image"], sprites["quads"][self.direction][self.spriteCounter], (self.x)-32, (self.y)-64)
	end
end

function PotSpider.update(self, map, dt)
	if knight.isGrabbing and knight.grabbedEnemy == self then
		self.x = knight.x - 16
		self.y = knight.y - 16

		self.spriteCounter = 1
		return
	end

	if self:collidesWith(knight) then
		knight:knockback(self, 5)
	end

	if self:isInRange(knight) and (self.state == "sleep" or self.state == "stand") then
		self.state = "walk"
		self.waitingTimer = 0
		
		if self:xDistance(knight) > self:yDistance(knight) then
			if self:isLeftOf(knight) then
				self.direction  = "right"
			elseif self:isRightOf(knight) then
				self.direction  = "left"
			end
		else
			if self:isAbove(knight) then
				self.direction  = "down"
			elseif self:isBelow(knight) then
				self.direction  = "up"
			end
		end
	end

	self.waitingTimer = self.waitingTimer + dt
	if self.waitingTimer > 3 then
		self.state = "sleep"
		return
	elseif self.waitingTimer > 1.5 then
		self.state = "stand"
		return
	end

	self.moveTimer = self.moveTimer + dt
	if self.moveTimer < 0.10 then
		return
	end
	self.moveTimer = 0
	
	self.spriteCounter = self.spriteCounter + 1
	if self.spriteCounter > 3 then
		self.spriteCounter = 1
	end

	if self.state == "walk" then
		self:move(self.direction, self.speed)
	end
end

function PotSpider.isInRange(self, enemy)
	local xWithinRange = math.abs(self.x - enemy.x) < 96
	local yWithinRange = math.abs(self.y - enemy.y) < 96

	return (xWithinRange and yWithinRange)
end
