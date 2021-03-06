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
    self.spriteTimer = 0
	self.speed = 12

	self.state = "stand"
	self.waitingTimer = 0
	self.direction  = "left"

	self.spriteName = "potSpider"
	self.name = "potSpider"
end

function PotSpider.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	local sprites = images:getImage(self.spriteName)
	if self.state == "sleep" then
		love.graphics.draw(sprites["image"], sprites["quads"]["sleep"..self.direction][1], (self.x)-32, (self.y)-64)
	elseif self.state == "stand" then
        if self.spriteCounter >= 3 then
            self.spriteCounter = 1
        end
		love.graphics.draw(sprites["image"], sprites["quads"]["stand"..self.direction][self.spriteCounter], (self.x)-32, (self.y)-64)
	else
        if self.spriteCounter >= 4 then
            self.spriteCounter = 1
        end
		love.graphics.draw(sprites["image"], sprites["quads"][self.direction][self.spriteCounter], (self.x)-32, (self.y)-64)
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
    if not self:isInRange(knight) and self.state == "walk" then
        self.state = "stand"
    end
    
	--[[self.waitingTimer = self.waitingTimer + dt
	if self.waitingTimer > 3 then
		self.state = "sleep"
		return
	elseif self.waitingTimer > 1.5 then
		self.state = "stand"
		return
	end--]]

    --[[
	self.moveTimer = self.moveTimer + dt
	if self.moveTimer < 0.10 then
		return
	end
	self.moveTimer = 0
    --]]
	
    self.spriteTimer = self.spriteTimer + dt
	if self.spriteTimer > .15 then
        if self.state == "walk" then
            if self.spriteCounter > 3 then
                self.spriteCounter = 1
            end
        end
        if self.state == "stand" then
            if self.spriteCounter > 2 then
                self.spriteCounter = 1
            end
        end
        self.spriteCounter = self.spriteCounter + 1
        
        self.spriteTimer = 0
	end
    
	

	if self.state == "walk" then
        if self:isLeftOf(knight) then
            self.x = self.x + 1
        end
		if self:isRightOf(knight) then
			self.x = self.x - 1
		end
		if self:isAbove(knight) then
			self.y = self.y + 1
		end
        if self:isBelow(knight) then
			self.y = self.y - 1
		end
        --[[
        if self.direction == "left" then
            self.x = self.x - 1
        elseif self.direction == "up" then
            self.y = self.y - 1
        elseif self.direction == "right" then
            self.x = self.x + 1
        elseif self.direction == "down" then
            self.y = self.y + 1
        end
        --]]
        --self:move(self.direction, self.speed)
	end
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
end

function PotSpider.isInRange(self, enemy)
	local xWithinRange = math.abs(self.x - enemy.x) < 96
	local yWithinRange = math.abs(self.y - enemy.y) < 96

	return (xWithinRange and yWithinRange)
end
