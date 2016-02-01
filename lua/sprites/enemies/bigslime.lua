require("lua/sprites/enemy")

Bigslime = {}
Bigslime.__index = Bigslime


setmetatable(Bigslime, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Bigslime:_init(x, y)
	Enemy._init(self, x, y, 64, 64, "large", 8, "slimeball", "eye", "diamond")

	self.moveTimer = 0
	self.spriteCounter = 1

	self.speed = 8
	self.direction = "down"
	self.spriteName = "bigslime"
	self.name = "bigslime"
end

function Bigslime.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	local sprites = images:getImage(self.spriteName)
	love.graphics.rectangle("fill", self.x-32, self.y-32, 64, 64)
	love.graphics.draw(sprites, (self.x)-32, (self.y)-32)
	
end

function Bigslime.update(self, map, dt)
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
	
	self:moveToward(knight)
end

function Bigslime.damage(self)
	if not knight.isGrabbing then
		return
	end
	
	Enemy.damage(self)
	
	if self.health <= 0 then
		--spawn 2 slimes
		local slime1 = Slime(self.x, self.y)
		local slime2 = Slime(self.x+self.width, self.y+self.height)
		
		table.insert(map.enemies, slime1)
		table.insert(map.enemies, slime2)
	end
end

function Bigslime.knockback(self, other)
	if knight.isGrabbing then
		return
	end
	Enemy.knockback(self, other)
end

function Bigslime.isInRange(self, enemy)
	local xWithinRange = math.abs(self.x - enemy.x) < 200
	local yWithinRange = math.abs(self.y - enemy.y) < 200

	return (xWithinRange and yWithinRange)
end
