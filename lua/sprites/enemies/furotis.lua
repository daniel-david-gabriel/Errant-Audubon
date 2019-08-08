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
	Enemy._init(self, x, y, 32, 32, "small", 8, "claw", "eye", "tuft")

	self.speed = 6
	self.xSpeed = 0
	self.ySpeed = 0
	

	self.state = "keep_distance"
	self.direction  = "down"

	self.spriteTimer = 0
	self.charge_max = 60
	
	self.magicCounter = 0
	self.magicTimer = 30
	
	self.skid_angle = 0
	
	self.garbage = false
	
	self.spriteName = "Furotis"
	self.name = "Furotis"
end

function Furotis.draw(self)
    
	if options.debug then
		love.graphics.print((self.magicTimer), (self.x)-32, (self.y)-87)
		love.graphics.print((self.health), (self.x)-32, (self.y)-70)
		love.graphics.setColor(0, 255, 0, 128)
		love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	end
	
	local sprites = images:getImage(self.spriteName)
	
	love.graphics.setColor(0, 100, 100, 128)		-- makeshift shadow
	love.graphics.ellipse("fill", self.x-19, self.y - 1, 16, 4)
	
	if self.state == "charge" or self.state == "charge_attack" or self.state == "stunned" then
		love.graphics.setColor(255, 255, 128, 255)
	else
		love.graphics.setColor(255, 255, 255, 255)
	end
	
	if self.state == "skid" then
		love.graphics.draw(sprites["image"], sprites["quads"][self.direction][2], (self.x)-32, (self.y)-64)
	else
		love.graphics.draw(sprites["image"], sprites["quads"][self.direction][1], (self.x)-32, (self.y)-64)
	end
end

function Furotis.update(self, map, dt)
	
	if self.state ~= "lunge_skid" and self.state ~= "stunned" and (knight.STATE == "LUNGE" or knight.STATE == "WALL_SLIDE") then
		local collisionSprite = Sprite(self.x-16, self.y-16, 70, 70)
		if collisionSprite:collidesWith(knight) then
			
			knight.STATE = "STAND"
			knight.xSpeed = 0
			knight.ySpeed = 0
			
        	table.insert(map.effects, Dust(self.x-24, self.y+8))
			
			self.skid_angle = math.atan2(knight.y-self.y, knight.x-self.x)
			self.state = "lunge_skid"
			self.spriteTimer = 20
		end
	end
	
  	if self:collidesWith(knight) then
		knight:knockback(self, 10)
	end
	
	if self.state == "lunge_skid" then
		self:move("left", self.spriteTimer*math.cos(self.skid_angle))
		self:move("up", self.spriteTimer*math.sin(self.skid_angle))
		
		self.spriteTimer = self.spriteTimer - 1
		if self.spriteTimer <= 0 then
			self.spriteTimer = 100
			self.state = "stunned"
		end
		return
	end
	
	if self.state == "stunned" then
		self.spriteTimer = self.spriteTimer - 1
		if self.spriteTimer <= 0 then
			self.spriteTimer = 9
			self.state = "keep_distance"
		end
		return
	end
	
	
	if self.state == "skid" then
		self.spriteTimer = self.spriteTimer - 1
		if self.spriteTimer <= 0 then
			self.spriteTimer = 9
			self.state = "keep_distance"
		end
		return
	end
	
	if self.state == "keep_distance" then
		local radius = 160
		local x_distance = self.x - knight.x
		local y_distance = self.y - knight.y
		local distance = math.sqrt(x_distance*x_distance + y_distance*y_distance)
		
		if distance < radius then
			self.state = "dash_away"
	        table.insert(map.effects, Dust(self.x-24, self.y+8))
			self.spriteTimer = 9
			self.xSpeed = math.cos(math.atan2(knight.y-self.y, knight.x-self.x))
			self.ySpeed = math.sin(math.atan2(knight.y-self.y, knight.x-self.x))
		end
		
		self.spriteTimer = self.spriteTimer - 1
		if self.spriteTimer <= 0 then
			local rando = math.random(100)
			if rando < 40 then
				self.state = "shoot_fireball"
			end
			if rando >= 75 then
				self.spriteTimer = self.charge_max
				self.state = "charge"
			else
				self.spriteTimer = 20
			end
		end
		
		return
	end
	
	if self.state == "charge" then
		self.spriteTimer = self.spriteTimer - 1
		if self.spriteTimer == 5 then
			self.xSpeed = math.cos(math.atan2(knight.y-self.y, knight.x-self.x))
			self.ySpeed = math.sin(math.atan2(knight.y-self.y, knight.x-self.x))
		end
		
		if self.spriteTimer <= 0 then
			--hitStopTimer = 10
			self.spriteTimer = 24
			self.state = "charge_attack"
		end
		
		table.insert(map.effects, Smoke(self.x+32+(math.random()*(1.5)*32)-64, self.y-16+(math.random()*32)))
		return
	end
	
	if self.state == "charge_attack" then
		self:move("right", self.spriteTimer*self.xSpeed)
		self:move("down", self.spriteTimer*self.ySpeed)
		
		self.spriteTimer = self.spriteTimer - 1
		if self.spriteTimer <= 0 then
			self.spriteTimer = 9
			self.state = "keep_distance"
		end
		
		table.insert(map.effects, Smoke(self.x, self.y))
		return
	end
	
	if self.state == "dash_away" then
		self:move("left", 9*self.xSpeed)
		self:move("up", 9*self.ySpeed)
		self.spriteTimer = self.spriteTimer - 1
		if self.spriteTimer <= 0 then
			if math.random(10) >= 8 then
				self.state = "lunge_attack"
				self.spriteTimer = 12
				self.xSpeed = math.cos(math.atan2(knight.y-self.y, knight.x-self.x))
				self.ySpeed = math.sin(math.atan2(knight.y-self.y, knight.x-self.x))
			else
				self.spriteTimer = 9
				self.state = "keep_distance"
			end
		end
		return
	end
	
	if self.state == "lunge_attack" then
		self:move("right", 5*self.xSpeed)
		self:move("down", 5*self.ySpeed)
		self.spriteTimer = self.spriteTimer - 1
		if self.spriteTimer <= 0 then
			self.spriteTimer = 9
			self.state = "keep_distance"
		end
		return
	end
	
	
	if self.state == "shoot_fireball" then
		
		table.insert(map.enemies, Fireball(self.x-20, self.y-10))
		
		self.spriteTimer = 9
		self.state = "keep_distance"
	end
	
end

function Furotis.damage(self)
	if  self.state == "charge" or self.state == "charge_attack"  or self.state == "stunned"then
		Enemy.damage(self)
		table.insert(map.effects, AttackHit(self.x-48, self.y-48))
		hitStopTimer = 12
		self.state = "skid"
		self.spriteTimer = 20
	else
		self.state = "skid"
		self.spriteTimer = 20
	end
end

function Furotis.isInRange(self, enemy)
	local xWithinRange = math.abs(self.x - enemy.x) < 96
	local yWithinRange = math.abs(self.y - enemy.y) < 96

	return (xWithinRange and yWithinRange)
end
