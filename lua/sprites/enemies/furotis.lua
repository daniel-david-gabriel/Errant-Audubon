require("lua/sprites/enemy")

Furotis = {}
Furotis.__index = Furotis


setmetatable(Furotis, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Furotis:_init(x, y)
	Enemy._init(self, x, y, 32, 32, "small", 2, "claw", "eye", "tuft")

	self.speed = 6

	self.state = "stand"
	self.direction  = "down"

	self.spriteTimer = 0
	
	self.magicCounter = 0
	self.magicTimer = 30

	self.spriteName = "Furotis"
	self.name = "Furotis"
end

function Furotis.knockback(self, other)
	if self.state == "vulnerable" then
		--self.health = 0
		--self:damage()
	else
		self.health = self.health + 1
		self.state = "slide"
		self.spriteTimer = 15
		self.slide_vel_x = 6
	end
end

function Furotis.draw(self)
    
	if options.debug then
		love.graphics.print((self.magicTimer), (self.x)-32, (self.y)-87)
		love.graphics.print((self.health), (self.x)-32, (self.y)-70)
		love.graphics.setColor(0, 255, 0, 128)
		love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	end
	
	local sprites = images:getImage(self.spriteName)
	
	if self.state == "vulnerable" or self.magicTimer <= 30 then
		love.graphics.setColor(255, 255, 180, 255)
		love.graphics.draw(sprites["image"], sprites["quads"][self.direction][3], (self.x)-32, (self.y)-64)
	else
		love.graphics.setColor(255, 255, 255, 255)
	
		if self.state == "slide" or (self.spriteTimer > 0 and self.state == "stand") then
			love.graphics.draw(sprites["image"], sprites["quads"][self.direction][2], (self.x)-32, (self.y)-64)
		elseif self.state == "cast spell" then
			love.graphics.draw(sprites["image"], sprites["quads"][self.direction][3], (self.x)-32, (self.y)-64)
		else
			love.graphics.draw(sprites["image"], sprites["quads"][self.direction][1], (self.x)-32, (self.y)-64)
		end
	end
	--love.graphics.print((self.state), 500, 230)
end

function Furotis.update(self, map, dt)
  	
  	if self:collidesWith(knight) then
		knight:knockback(self, 20)
		self.state = "stand"
	end
	
	if self.state == "cast spell" then
		local directions = {}
		if self.magicTimer > 0 then
			self.magicTimer = self.magicTimer - 1
		else
			self.magicCounter = self.magicCounter + 1
			
			if self.direction == "down" then
				directions = {1, 2, 3}
			end
			if self.direction == "left" then
				directions = {4, 5, 6}
			end
			if self.direction == "up" then
				directions = {7, 8, 9}
			end
			if self.direction == "right" then
				directions = {10, 11, 12}
			end
	        table.insert(map.enemies, Fireball(self.x-20, self.y-10, directions[1], 1))
	        table.insert(map.enemies, Fireball(self.x-20, self.y-10, directions[2], 2))
	        table.insert(map.enemies, Fireball(self.x-20, self.y-10, directions[3], 1))
			--[[[
			if self.magicCounter == 1 then
	           	table.insert(map.enemies, Fireball(self.x-20, self.y-10, directions[1], 1))
	        elseif self.magicCounter == 2 then
	           	table.insert(map.enemies, Fireball(self.x-20, self.y-10, directions[2], 2))
	        elseif self.magicCounter >= 3 then
	           	table.insert(map.enemies, Fireball(self.x-20, self.y-10, directions[3], 1))
				self.magicCounter = 0
				self.magicTimer = 300
				self.state = "stand"
				return
			end
			self.magicTimer = 5
			--]]
			self.magicCounter = 0
			self.magicTimer = 300
			self.spriteTimer = 50
			self.state = "vulnerable"
			return
		end
	end
	
	if self.state == "vulnerable" then
		if self.spriteTimer > 0 then
			self.spriteTimer = self.spriteTimer - 1
		end
		
		if self.spriteTimer == 0 then
			self.state = "stand"
		end
		
	end
	
	if self.state == "stand" then
		if self.spriteTimer > 0 then
			self.spriteTimer = self.spriteTimer - 1
		end
		
		if self.magicTimer > 0 then
			self.magicTimer = self.magicTimer - 1
		else
			--self.magicTimer = 60
			self.state = "cast spell"
			return
		end
	end
	
	if self.state == "slide" then
		self:move(oppositeDirection(self.direction), self.slide_vel_x)
		
		if self.spriteTimer < 10 then
			self.slide_vel_x = self.slide_vel_x - 1
			if self.slide_vel_x == 7 then
				table.insert(map.effects, Dust(self.x-24, self.y-8))
			end
		end
		
		if self.slide_vel_x == 0 then
			self.spriteTimer = 18
			self.state = "stand"
			return
		end
		
		self.spriteTimer = self.spriteTimer - 1
	else
		--if not self.state == "cast spell" then
	    	num = math.abs(self.x - knight.x)
			if self.x < knight.x and self.y > knight.y then
				if self.y - num > knight.y then
					self.direction = "up"
				else
					self.direction = "right"
				end
			elseif self.x > knight.x and self.y > knight.y then
				if self.y - num > knight.y then
					self.direction = "up"
				else
					self.direction = "left"
				end
			elseif self.x < knight.x and self.y < knight.y then
				if self.y + num > knight.y then
					self.direction = "right"
				else
					self.direction = "down"
				end
			elseif self.x > knight.x and self.y < knight.y then
				if self.y + num > knight.y then
					self.direction = "left"
				else
					self.direction = "down"
				end
			end
		--end
	end
	  
	--[[if knight.isGrabbing and knight.grabbedEnemy == self then
		self.x = knight.x - 16
		self.y = knight.y - 16

		self.spriteCounter = 1
		return
	end
   --]] 
end

function Furotis.isInRange(self, enemy)
	local xWithinRange = math.abs(self.x - enemy.x) < 96
	local yWithinRange = math.abs(self.y - enemy.y) < 96

	return (xWithinRange and yWithinRange)
end
