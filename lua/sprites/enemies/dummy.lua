require("lua/sprites/enemy")
require("lua/sprites/effects/grass")

Dummy = {}
Dummy.__index = Dummy


setmetatable(Dummy, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Dummy:_init(x, y)
	Enemy._init(self, x, y, 32, 32, "small", 3, "claw", "eye", "tuft")

	self.spriteCounter = 1
    self.spriteTimer = 0
    
    self.state = "STATE_ONE"
    self.state_counter = 0
    
    self.moveCounter = 0
    self.bounce_dampen = 1
	self.bounce_counter = 0
	
	self.draw_offset = 0
    
	self.spriteName = "Dummy"
	
	self.grass_counter = 0
	
	self.xDirection = "left"
	self.yDirection = "down"
	self.xSpeed = 0
	self.ySpeed = 0
	
	self.maxSpeed = 6
	self.speed = 0
end

function Dummy.draw(self)
	
    love.graphics.print(self.xSpeed, 80, 50)
    
	if options.debug then
		love.graphics.setColor(0, 255, 0, 128)
		love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	end
	
	love.graphics.setColor(255, 255, 255, 255)
	local sprites = images:getImage(self.spriteName)
	
	love.graphics.draw(sprites["image"], sprites["quads"][self.spriteCounter], (self.x)-32, (self.y)-64-self.draw_offset)
	
	--love.graphics.print(self.y, 300, 120)
end

function Dummy.update(self, map, dt)
	
	--if self.grass_counter < 30 then
	--	self.grass_counter = self.grass_counter + 1
	--	table.insert(map.effects, Grass(12*32-math.random()*8*32, 12*32-math.random()*6*32))
	--end
	
	if self.speed > 0 then
		self.speed = self.speed - 0.1
	end
	
	if self.state == "skid" then
		if self.moveCounter >= math.pi then
            table.insert(map.effects, Dust(self.x-24, self.y+8))
			
			self.moveCounter = 0
			self.draw_offset = 0
			
			
			self.bounce_dampen = self.bounce_dampen + 1
			
			if self.bounce_counter < 2 then
				self.bounce_counter = self.bounce_counter + 1
			else
				self.state = "STATE_ONE"
				self.spriteCounter = 1
				self.moveCounter = 0
				self.bounce_dampen = 1
				self.bounce_counter = 0
				return
			end
		else
			self.moveCounter = self.moveCounter + math.pi*(1/15)
		end
		
		--self:move(oppositeDirection(self.direction), 2)
		self:move("left", self.speed*self.xSpeed)
		self:move("up", self.speed*self.ySpeed)
		
		if math.cos(self.moveCounter) ~= 1 and math.cos(self.moveCounter) ~= -1 then
			--self:move("up", math.cos(self.moveCounter)*(1/self.bounce_dampen))
			self.draw_offset  = self.draw_offset + math.cos(self.moveCounter)*(4/self.bounce_dampen)
		end
	end
	
	
	if self.state == "STATE_TWO" then
        self.state_counter = self.state_counter - 1
        if self.state_counter <= 0 then
            self.state = "STATE_ONE"
            self.spriteCounter = 1
        end
    end
    
	
	if  self.state == "STATE_ONE" and knight.STATE == "LUNGE" then
		local collisionSprite = Sprite(self.x-16, self.y-16, 70, 70)
		if collisionSprite:collidesWith(knight) then
			self:damage()
			self:knockback()
		end
	end
end

function Dummy.knockback(self)
	--self.direction = self:determineDirection(knight)
	if self.x < knight.x then
		self.xDirection = "right"
	else
		self.xDirection = "left"
	end
	
	if self.y < knight.y then
		self.yDirection = "down"
	else
		self.yDirection = "up"
	end
	
	--local h = ((knight.x-self.x)^2+(knight.y-self.y)^2)^0.5
	
	self.xSpeed = math.cos(math.atan2(knight.y-self.y, knight.x-self.x))
	self.ySpeed = math.sin(math.atan2(knight.y-self.y, knight.x-self.x))
	
	self.state = "skid"
	return
end

function Dummy.damage(self)
    --if self.state == "STATE_ONE" then
        table.insert(map.effects, AttackHit(self.x-48, self.y-48))
    	self.speed = self.maxSpeed
		hitStopTimer = 12
        self.state = "STATE_TWO"
        self.state_counter = 20
        self.spriteCounter = 2
    --end
end
