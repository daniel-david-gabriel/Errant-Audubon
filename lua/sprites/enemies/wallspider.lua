require("lua/sprites/enemy")

WallSpider = {}
WallSpider.__index = WallSpider


setmetatable(WallSpider, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function WallSpider:_init(x, y)
	Enemy._init(self, x, y, 32, 32, "small", 3, "slimeball", "eye", "diamond")

	self.moveTimer = 0
	self.spriteCounter = 0
    self.spriteTimer = 0 
	
	self.orientation = "counter-clockwise"
	
	self.DEST_X = 0
	self.DEST_Y = 0
	self.attack_lock = false
	
	self.x_difference = self.x - knight.x
	self.y_difference = self.y - knight.y
	
	self.state = "FIND_WALL"
	self.speed = 2
	self.facingDirection = "down"
	self.movingDirection = "right"
	--self.sprites = images:getImage("slime")
	self.name = "wallspider"
end

function WallSpider.draw(self)
	if self.state == "attack" then
		love.graphics.setColor(255, 0, 0)
	elseif self.state == "attack_prep" then
		love.graphics.setColor(150, 0, 140)
	else
		love.graphics.setColor(100, 180, 50)
	end
	love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	
	local moveAngle = math.atan2(self.y_difference, self.x_difference)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.ellipse("fill", self.x-16 + 32*math.cos(math.pi + moveAngle), self.y-16 + 32*math.sin(math.pi + moveAngle), 2, 2)
    
end

function WallSpider.update(self, map, dt)
	 
	if self:collidesWith(knight) then
		knight:knockback(self, 5)
	end
	
	self.spriteCounter = self.spriteCounter - 1
	
	if self.state == "attack_prep" then 
		if self.spriteCounter <= 0 then
			self.spriteCounter = 20
			self.state = "attack"
		end
		return
	end
	
	if self.state == "attack" then 
		if self.spriteCounter <= 0 or self:collidesWith(knight) then
			self.state = "FIND_WALL"
			return
		end
		
        local move_percent = 0.1
		self:move("right", move_percent*(self.DEST_X - self.x))
		self:move("down", move_percent*(self.DEST_Y - self.y))
	end
	
	if self.spriteCounter <= 0 then
		if math.random(100) >= 90 and not self.attack_lock then
			local move_angle = math.atan2(self.y - knight.y, self.x - knight.x)
			local radius = 270
			
			self.attack_lock = true
			self.DEST_X = self.x + radius*math.cos(math.pi + move_angle)
			self.DEST_Y = self.y + radius*math.sin(math.pi + move_angle)
			
			self.spriteCounter = 50
			self.state = "attack_prep"
			return
		end
		if math.abs(self.x - knight.x) > math.abs(self.x_difference) or math.abs(self.y - knight.y) > math.abs(self.y_difference) then
			if self.orientation == "clockwise" then
				self.orientation = "counter-clockwise"
			elseif self.orientation == "counter-clockwise" then
				self.orientation = "clockwise"
			end
		end
		
		self.x_difference = self.x - knight.x
		self.y_difference = self.y - knight.y
		self.spriteCounter = math.random(10, 40)
	end
	
	-- CLOCKWISE --
	if self.facingDirection == "down" and self.orientation == "clockwise" then
	    self.movingDirection = "right"
	elseif self.facingDirection == "right" and self.orientation == "clockwise" then
	    self.movingDirection = "up"
	elseif self.facingDirection == "up" and self.orientation == "clockwise" then
		self.movingDirection = "left"
	elseif self.facingDirection == "left" and self.orientation == "clockwise" then
		self.movingDirection = "down"
	end
    
    if self.state == "FIND_WALL" and self.orientation == "clockwise" then
    	self:move(self.facingDirection, self.speed)
	    --check front
	    if not map:canMove(self, self.facingDirection, self.speed) then
	    	self.state = "MOVE_ALONG_WALL"
	    	return
	    end
	    
	    --check left
	    if not map:canMove(self, self.movingDirection, self.speed) then
	    	if self.facingDirection == "down" then
	    		self.facingDirection = "right"
	    	elseif self.facingDirection == "right" then
	    		self.facingDirection = "up"
	    	elseif self.facingDirection == "up" then
	    		self.facingDirection = "left"
	    	elseif self.facingDirection == "left" then
	    		self.facingDirection = "down"
	    	end
			self.state = "MOVE_ALONG_WALL"
	    	return
	    end
	    
	    --check right
	    if not map:canMove(self, oppositeDirection(self.movingDirection), self.speed) then
	    	if self.facingDirection == "down" then
	    		self.facingDirection = "left"
	    	elseif self.facingDirection == "right" then
	    		self.facingDirection = "down"
	    	elseif self.facingDirection == "up" then
	    		self.facingDirection = "right"
	    	elseif self.facingDirection == "left" then
	    		self.facingDirection = "up"
	    	end
			self.state = "MOVE_ALONG_WALL"
	    	return
	    end
    	return
    end
    
    if self.state == "MOVE_ALONG_WALL" and self.orientation == "clockwise" then
		self.attack_lock = false
    	self:move(self.movingDirection, self.speed)
    	if not map:canMove(self, self.movingDirection, self.speed) then
    		if self.facingDirection == "down" then
	    		self.facingDirection = "right"
	    	elseif self.facingDirection == "right" then
	    		self.facingDirection = "up"
	    	elseif self.facingDirection == "up" then
	    		self.facingDirection = "left"
	    	elseif self.facingDirection == "left" then
	    		self.facingDirection = "down"
	    	end
			self.state = "MOVE_ALONG_WALL"
	    	return
    	end
    	
    	if map:canMove(self, self.facingDirection, self.speed) then
	    	self.state = "FIND_WALL"
	    	return
	    end
    end
	
	
	-- COUNTER-CLOCKWISE --
	if self.facingDirection == "down" and self.orientation == "counter-clockwise" then
	    self.movingDirection = "left"
	elseif self.facingDirection == "right" and self.orientation == "counter-clockwise" then
	    self.movingDirection = "down"
	elseif self.facingDirection == "up" and self.orientation == "counter-clockwise" then
		self.movingDirection = "right"
	elseif self.facingDirection == "left" and self.orientation == "counter-clockwise" then
		self.movingDirection = "up"
	end
    
    if self.state == "FIND_WALL" and self.orientation == "counter-clockwise" then
    	self:move(self.facingDirection, self.speed)
	    --check front
	    if not map:canMove(self, self.facingDirection, self.speed) then
	    	self.state = "MOVE_ALONG_WALL"
	    	return
	    end
	    
	    --check left
	    if not map:canMove(self, self.movingDirection, self.speed) then
	    	if self.facingDirection == "down" then
	    		self.facingDirection = "left"
	    	elseif self.facingDirection == "right" then
	    		self.facingDirection = "down"
	    	elseif self.facingDirection == "up" then
	    		self.facingDirection = "right"
	    	elseif self.facingDirection == "left" then
	    		self.facingDirection = "up"
	    	end
			self.state = "MOVE_ALONG_WALL"
	    	return
	    end
	    
	    --check right
	    if not map:canMove(self, oppositeDirection(self.movingDirection), self.speed) then
	    	if self.facingDirection == "down" then
	    		self.facingDirection = "right"
	    	elseif self.facingDirection == "right" then
	    		self.facingDirection = "up"
	    	elseif self.facingDirection == "up" then
	    		self.facingDirection = "left"
	    	elseif self.facingDirection == "left" then
	    		self.facingDirection = "down"
	    	end
			self.state = "MOVE_ALONG_WALL"
	    	return
	    end
    	return
    end
    
    if self.state == "MOVE_ALONG_WALL" and self.orientation == "counter-clockwise" then
		self.attack_lock = false
    	self:move(self.movingDirection, self.speed)
    	if not map:canMove(self, self.movingDirection, self.speed) then
    		if self.facingDirection == "down" then
	    		self.facingDirection = "left"
	    	elseif self.facingDirection == "right" then
	    		self.facingDirection = "down"
	    	elseif self.facingDirection == "up" then
	    		self.facingDirection = "right"
	    	elseif self.facingDirection == "left" then
	    		self.facingDirection = "up"
	    	end
			self.state = "MOVE_ALONG_WALL"
	    	return
    	end
    	
    	if map:canMove(self, self.facingDirection, self.speed) then
	    	self.state = "FIND_WALL"
	    	return
	    end
    end
end















