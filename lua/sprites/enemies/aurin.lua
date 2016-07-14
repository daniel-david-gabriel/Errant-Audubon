require("lua/sprites/enemy")

Aurin = {}
Aurin.__index = Aurin


setmetatable(Aurin, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Aurin:_init(x, y)
	Enemy._init(self, x, y, 32, 32, "small", 6, "claw", "eye", "tuft")
	
	self.speed = 6

	self.state = "stand"
	self.direction  = "down"

	self.slide_vel_x = 0
	self.slide_vel_y = 0
	self.approachDirectionX = "right"
	self.approachDirectionY = "down"
	self.spriteTimer = 0
	
	self.stateTimer = (math.random()*4) + 1
	self.nextState = math.random(10)

	self.spriteName = "aurin"
	self.name = "aurin"
end

function Aurin.knockback(self, other)
	self.state = "slide"
	self.slide_vel_x = 9
end

function Aurin.draw(self)
    
	love.graphics.setColor(255, 255, 255, 255)
	local sprites = images:getImage(self.spriteName)
	if self.state == "slide" then
		love.graphics.draw(sprites["image"], sprites["quads"]["slide"][self.direction][1], (self.x)-32, (self.y)-32)
	else
		if self.state == "stand" and self.nextState <= 2 then
			love.graphics.setColor(255, 0, 255, 255)
		else
			love.graphics.setColor(255, 255, 255, 255)
		end
		love.graphics.draw(sprites["image"], sprites["quads"][self.direction][1], (self.x)-32, (self.y)-32)
	end
	--love.graphics.setColor(0, 0, 0, 128)
	--love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
  
	--love.graphics.print(self.spriteTimer, 200, 200)
	--love.graphics.print((self.slide_vel_y), 200, 220)
end

function Aurin.update(self, map, dt)
  	
  	if self:collidesWith(knight) then
		knight:knockback(self, 5)
		self.state = "stand"
	end
  	
	if self.state == "approach" then
		self:move(self.approachDirectionX, self.slide_vel_x)
		self:move(self.approachDirectionY, self.slide_vel_y)
		self.slide_vel_y = self.slide_vel_y - 1
		self.slide_vel_x = self.slide_vel_x - 1
		if self.slide_vel_y == 0 then
			self.stateTimer = (math.random()*4) + 1
			self.nextState = math.random(10)
			self.state = "stand"
		end
		return
	end
	
	if self.state == "side_jump" then
		self.spriteTimer = self.spriteTimer + dt*5
		if self.slide_vel_x == 0 then
			self:move("right", 6*math.cos(self.spriteTimer))
			self:move("down", 6*math.sin(self.spriteTimer))
		elseif self.slide_vel_x == 1 then
			self:move("up", 6*math.sin(self.spriteTimer))
			self:move("left", 6*math.cos(self.spriteTimer))
		elseif self.slide_vel_x == 2 then
			self:move("down", 6*math.cos(self.spriteTimer))
			self:move("left", 6*math.sin(self.spriteTimer))
		elseif self.slide_vel_x == 3 then
			self:move("up", 6*math.cos(self.spriteTimer))
			self:move("right", 6*math.sin(self.spriteTimer))
		end
		
		if self.spriteTimer > math.pi/2 then
			self.spriteTimer = 0
			self.stateTimer = (math.random()*4) + 1
			self.nextState = math.random(10)
			self.state = "stand"
		end
	end
	
	if self.state == "stand" then
		self.spriteTimer = self.spriteTimer + dt
		if self.spriteTimer > self.stateTimer then
			self.spriteTimer = 0
			if self.nextState > 2 then
				if self.y > knight.y then
					self.approachDirectionY = "up"
				end
				if self.y < knight.y then
					self.approachDirectionY = "down"
				end
				if self.x > knight.x then
					self.approachDirectionX = "left"
				end
				if self.x < knight.x then
					self.approachDirectionX = "right"
				end
				self.slide_vel_x = 8
				self.slide_vel_y = 8
				self.state = "approach"
				return
			else
				if self.direction == "down" then
					self.slide_vel_x = 0
				elseif self.direction == "up" then
					self.slide_vel_x = 1
				elseif self.direction == "left" then
					self.slide_vel_x = 2
				elseif self.direction == "right" then
					self.slide_vel_x = 3
				end
				self.state = "side_jump"
				return
			end
		end
	end
	
	if self.state == "slide" then
		self:move(oppositeDirection(self.direction), self.slide_vel_x)
		self.slide_vel_x = self.slide_vel_x - 1
		if self.slide_vel_x == 7 then
			table.insert(map.effects, Dust(self.x-24, self.y-8))
		end
		if self.slide_vel_x == 0 then
			self.stateTimer = (math.random()*4) + 1
			self.state = "stand"
		end
	else
    	self.direction = self:determineDirection(knight)
	end
	  
	--[[if knight.isGrabbing and knight.grabbedEnemy == self then
		self.x = knight.x - 16
		self.y = knight.y - 16

		self.spriteCounter = 1
		return
	end
   --]] 
end

function Aurin.isInRange(self, enemy)
	local xWithinRange = math.abs(self.x - enemy.x) < 96
	local yWithinRange = math.abs(self.y - enemy.y) < 96

	return (xWithinRange and yWithinRange)
end
