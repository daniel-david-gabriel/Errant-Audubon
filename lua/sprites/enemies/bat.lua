require("lua/sprites/enemy")

Bat = {}
Bat.__index = Bat


setmetatable(Bat, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Bat:_init(x, y)
	Enemy._init(self, x, y, 40, 32, "small", 2, "claw", "eye", "tuft")

	self.moveTimer = 0
	self.spriteCounter = 1
	self.speed = 8

	self.direction  = "down"

	self.spriteName = "bat"
	self.name = "bat"
end

function Bat.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	local sprites = images:getImage(self.spriteName)
	if self.isWaiting then
		love.graphics.drawq(sprites["image"], sprites["quads"][4], (self.x)-48, (self.y)-32)
	else
		love.graphics.drawq(sprites["image"], sprites["quads"][self.spriteCounter], (self.x)-48, (self.y)-32)
	end
end

function Bat.update(self, map, dt)
	if knight.isGrabbing and knight.grabbedEnemy == self then
		self.x = knight.x - 16
		self.y = knight.y - 16

		self.spriteCounter = 4
		return
	end

	if self:collidesWith(knight) then
		knight:knockback(self, 5)
	end
	
	if not self:isInRange(knight) then
		return
	end

	self.moveTimer = self.moveTimer + dt
	if self.moveTimer < 0.1 then
		return
	end
	self.moveTimer = 0
	self.spriteCounter = self.spriteCounter + 1
	if self.spriteCounter > 6 then
		self.spriteCounter = 1
	end
	
	self:moveToward(knight)
end

function Bat.isInRange(self, enemy)
	local xWithinRange = math.abs(self.x - enemy.x) < 96
	local yWithinRange = math.abs(self.y - enemy.y) < 96

	return (xWithinRange and yWithinRange)
end
