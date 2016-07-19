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
    self.spriteTimer = 0 
    
    self.jumpOffset = 0
    self.jumpCounter = 0
	self.jumpCounterMax = math.random(200) + 200
    self.jumpVelMax = 10
	self.jumpVel = self.jumpVelMax
	
	self.state = "WALK"
	
	self.speed = 2
	self.direction = "down"
	self.spriteName = "bigslime"
	self.name = "bigslime"
end

function Bigslime.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	local sprites = images:getImage(self.name)
	if self.state == "WALK" then
		love.graphics.draw(sprites["image"], sprites["quads"][self.direction][self.spriteCounter], (self.x)-32, (self.y)-32)
	elseif self.state == "JUMP" or self.state == "LAND" then
		if self.spriteCounter > 1 then
			love.graphics.setColor(0, 100, 100, 128)		
			love.graphics.ellipse("fill", self.x, self.y+16, 32, 16)
		end
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(sprites["image"], sprites["quads"]["jump"][self.direction][self.spriteCounter], (self.x)-32, (self.y)-32-self.jumpOffset)
	end
end

function Bigslime.update(self, map, dt)
	
	if self.state == "JUMP" then
		self.spriteTimer = self.spriteTimer + dt
		
		if self.spriteCounter <= 1 then
			if self.spriteTimer > 0.4 then
				self.spriteCounter = self.spriteCounter + 1
				self.spriteTimer = 0
			end
		else
			self:move(self.direction, self.speed*2)
			
			if self.jumpVel > self.jumpVelMax*(8/10) then
				self.spriteCounter = 2
			elseif self.jumpVel > 2 then
				self.spriteCounter = 3
			elseif self.jumpVel <= 2 and self.jumpVel > 0 then
				self.spriteCounter = 2
			else
				self.spriteCounter = 4
			end
			
			self.jumpOffset = self.jumpOffset + self.jumpVel
			self.jumpVel = self.jumpVel - 0.25
			
			if self.jumpVel <= -self.jumpVelMax then
				for i=1, 9 do
					table.insert(map.effects, Smoke(self.x+(math.random()*128)-64, self.y+32+(math.random()*64)-32))
				end
				camera.quake_duration = 40
				self.state = "LAND"
				self.jumpOffset = 0
				self.jumpVel = self.jumpVelMax
				self.jumpCounter = 0
				return
			end
		end
		return
	end
	
	if self.state == "LAND" then
		self.spriteCounter = 1
		
		if self.jumpCounter >= 100 then
			 self.jumpCounter = 0
			 self.state = "WALK"
			 self.jumpCounterMax = math.random(200) + 200
			 return
		else
			self.jumpCounter = self.jumpCounter + 1
		end
		
		return
	end
	
	if self:collidesWith(knight) then
		knight:knockback(self, 5)
	end
	
	if not self:isInRange(knight) then
		return
	end
	
	if self.state == "WALK" then
		self.spriteTimer = self.spriteTimer + dt
		self.jumpCounter = self.jumpCounter + 1
		
		if self.jumpCounter >= self.jumpCounterMax then
			self.state = "JUMP"
			self.spriteCounter = 1
			self.spriteTimer = 0
			return
		end
		
		if self.spriteTimer > 0.2 then
			self.spriteCounter = self.spriteCounter + 1
			self.spriteTimer = 0
	            
			if self.spriteCounter > 5 then
				self.spriteCounter = 1
			end
		end
		
		self.direction = self:determineDirection(knight)
		
		self:move(self.direction, self.speed)
	end
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
	if self.jumpOffset == 0 then
		Enemy.knockback(self, other)
	end
end

function Bigslime.isInRange(self, enemy)
	local xWithinRange = math.abs(self.x - enemy.x) < 500
	local yWithinRange = math.abs(self.y - enemy.y) < 500

	return (xWithinRange and yWithinRange)
end
