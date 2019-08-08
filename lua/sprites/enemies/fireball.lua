require("lua/sprites/enemy")
require("lua/sprites/effects/spark")

Fireball = {}
Fireball.__index = Fireball


setmetatable(Fireball, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Fireball:_init(x, y, direction)
	Enemy._init(self, x, y, 32, 32, "small", 1, "slimeball", "eye", "diamond")
	
	self.frameCounter = 1
	self.frameTimer = 0
	
	self.max_speed = 6
	
	self.speed = 0
	self.direction = direction
	
	self.name = "Fireball"
    
    self.SPEED_THING = 0
    
    self.quantity = 0
	self.count = 0
	
	self.moveAngle = math.atan2(knight.y - self.y, knight.x - self.x)
end

function Fireball.damage(self)
end
function Fireball.knockback(self)
end

function Fireball.draw(self)

	
	if options.debug then
		love.graphics.setColor(0, 255, 0, 128)
		love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	end
	
	love.graphics.setColor(255, 255, 255, 255)
	
	local sprites = images:getImage(self.name)
	love.graphics.draw(sprites["image"], sprites["quads"][self.frameCounter], (self.x)-32, (self.y)-32)
    
end

function Fireball.update(self, map, dt)
    
    if self.quantity == 100 then
    	self.quantity = 0
    else
    	self.quantity = self.quantity + 1
    end
    
    if self.quantity%8 == 0 then
	    table.insert(map.effects, Spark(self.x-36+math.random()*32, self.y-26+math.random()*10))
	end
	
	self.frameTimer = self.frameTimer + dt
	
	if self.frameTimer > 0.40 and self.frameCounter == 1 then
		self.frameCounter = 2
		self.frameTimer = 0
	end
	
	if self.frameTimer > 0.25 and self.frameCounter == 2 then
		self.frameCounter = 1
		self.frameTimer = 0
	end
	
	if self:collidesWith(knight) then
		knight:knockback(self, 10)
		self:despawn(map)
	end
	
	if self.count > math.pi*2 then
		self.count = math.pi*2
	else
		self.count = self.count + math.pi*(1/100)
	end
	
	--self:move("down", math.sin(self.count)*2)
	
	--self:move("right", math.cos(self.count)*2)
	
	local slow_speed = math.cos(self.count)*3
	if self.count > math.pi/2 then
		slow_speed = 0
	end
	
	local med_speed = 2
	local fast_speed = 3
	
	local a = true
	local b = true
	
	a = self:move("right", self.max_speed* math.cos(self.moveAngle))
	b = self:move("down", self.max_speed* math.sin(self.moveAngle))
	
	if not a or not b then
		self:despawn(map)
	end
	
	--[[
	if self.direction == 1 then
		if not self:move("down", med_speed) then
			self:despawn(map)
		end
		if not self:move("right", slow_speed) then
			self:despawn(map)
		end
	elseif self.direction == 2 then
		if not self:move("down", fast_speed) then
			self:despawn(map)
		end
	elseif self.direction == 3 then
		if not self:move("down", med_speed) then
			self:despawn(map)
		end
		if not self:move("left", slow_speed) then
			self:despawn(map)
		end
	elseif self.direction == 4 then
		if not self:move("left", med_speed) then
			self:despawn(map)
		end
		if not self:move("down", slow_speed) then
			self:despawn(map)
		end
	elseif self.direction == 5 then
		if not self:move("left", fast_speed) then
			self:despawn(map)
		end
	elseif self.direction == 6 then
		if not self:move("left", med_speed) then
			self:despawn(map)
		end
		if not self:move("up", slow_speed) then
			self:despawn(map)
		end
	elseif self.direction == 7 then
		if not self:move("up", med_speed) then
			self:despawn(map)
		end
		if not self:move("left", slow_speed) then
			self:despawn(map)
		end
	elseif self.direction == 8 then
		if not self:move("up", fast_speed) then
			self:despawn(map)
		end
	elseif self.direction == 9 then
		if not self:move("up", med_speed) then
			self:despawn(map)
		end
		if not self:move("right", slow_speed) then
			self:despawn(map)
		end
	elseif self.direction == 10 then
		if not self:move("right", med_speed) then
			self:despawn(map)
		end
		if not self:move("up", slow_speed) then
			self:despawn(map)
		end
	elseif self.direction == 11 then
		if not self:move("right", fast_speed) then
			self:despawn(map)
		end
	elseif self.direction == 12 then
		if not self:move("right", med_speed) then
			self:despawn(map)
		end
		if not self:move("down", slow_speed) then
			self:despawn(map)
		end
	end
	--]]
end

function Fireball.isInRange(self, enemy)
	local xWithinRange = math.abs(self.x - enemy.x) < 100
	local yWithinRange = math.abs(self.y - enemy.y) < 100

	return (xWithinRange and yWithinRange)
end
