require("lua/sprites/sprite")

Sword = {}
Sword.__index = Sword


setmetatable(Sword, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Sword:_init()
	Sprite._init(self, 0, 0, 64, 64)

	self.imageName = "sword"
	self.name = "sword weapon"

	self.beingUsed = false
	self.attackAnimation = 1
	self.facingDirection = "down"
	self.enemiesHit = {}
	
	self.timer_max = 40
	self.timer = self.timer_max
	
	self.xSpeed = 0
	self.ySpeed = 0
	
	self.xRand = math.random(10) - 5
	self.yRand = math.random(10) - 5
end

function Sword.use(self, knight)
	self.beingUsed = true
	
	--[[
	local moveAngle = math.atan2(knight.ySpeed, knight.xSpeed)
	if knight.xSpeed == 0 and knight.ySpeed == 0 then
		if knight.displayDirection == "down" then
			moveAngle = (1/2)*math.pi
		elseif knight.displayDirection == "left" then
			moveAngle = math.pi
		elseif knight.displayDirection == "up" then
			moveAngle = (3/2)*math.pi
		end
	end
	
	self.x = knight.x - 16 + 50 * math.cos(moveAngle)
	self.y = knight.y - 16 + 50 * math.sin(moveAngle)
	--]]
	
    
	self.x = knight.x
	self.y = knight.y
	self.facingDirection = knight.displayDirection
    
	if knight.displayDirection == "up" then
		self.y = self.y - self.height
		self.x = self.x - (self.width/4)
	elseif knight.displayDirection == "down" then
		self.y = self.y + (self.height/2)
		self.x = self.x - (self.width/4)
	elseif knight.displayDirection == "left" then
		self.y = self.y - (self.height/4)
		self.x = self.x - self.width
	elseif knight.displayDirection == "right" then
		self.y = self.y - (self.height/4)
		self.x = self.x + (self.width/2)
	end
	
    
    if knight.HOP_OFFSET >= 0 then
		self.y = self.y - knight.HOP_OFFSET
    end
end

function Sword.draw(self)
	
	--if self.beingUsed then
		if knight.STATE == "SWORD_SLASH" then
			love.graphics.setColor(255, 0, 0, 128)
			love.graphics.rectangle("fill", self.x-(self.width/2), self.y-(self.height/2), self.width, self.height)
		else
			love.graphics.setColor(0, 255, 0, 128)
			love.graphics.rectangle("fill", self.x-(self.width/2), self.y-(self.height/2), self.width, self.height)
		end
	--end

	--[[if self.beingUsed then
		--love.graphics.draw(images:getImage(self.imageName), self.x-32, self.y-32)
        love.graphics.setColor(255, 255, 255, 255)
        local sprites = images:getImage(self.name)
        
        if knight.STATE == "TOOL_USE" then
            if knight.tool_timer >= knight.tool_timer_max*(2/3) + 1 and knight.tool_timer <= knight.tool_timer_max then
                love.graphics.draw(sprites["image"], sprites["quads"][self.facingDirection][1], (self.x)-32, (self.y)-32)
            elseif knight.tool_timer >= (knight.tool_timer_max/3) + 1  and knight.tool_timer < knight.tool_timer_max*(2/3) + 1 then
                love.graphics.draw(sprites["image"], sprites["quads"][self.facingDirection][2], (self.x)-32, (self.y)-32)
            elseif knight.tool_timer > 0 and knight.tool_timer < (knight.tool_timer_max/3) + 1 then
                love.graphics.draw(sprites["image"], sprites["quads"][self.facingDirection][3], (self.x)-32, (self.y)-32)
            end
        else
            if knight.freeze_direction == true and knight.tool_timer == 0 then
                love.graphics.draw(sprites["image"], sprites["quads"][self.facingDirection][4], (self.x)-32, (self.y)-32)
            end
            if knight.STATE == "SWORD_SLASH" then
                if knight.tool_timer >= 20 and knight.tool_timer < 25 then
                    love.graphics.draw(sprites["image"], sprites["quads"][self.facingDirection][5], (self.x)-48, (self.y)-48)
                elseif knight.tool_timer > 0  and knight.tool_timer < 20 then
                    love.graphics.draw(sprites["image"], sprites["quads"][self.facingDirection][6], (self.x)-48, (self.y)-48)
                end
            end
        end
	end
    --]]
end

function Sword.update(self, dt)
	self:attack()
	
	
	if self.timer == self.timer_max	 then
		self.displayDirection = knight.displayDirection
		self.displayAngle = knight.move_angle
	end
	
	--[[
	if self.displayDirection == "up" then
		self.y = knight.y - self.height + self.yRand
		self.x = knight.x - (self.width/4) + self.xRand
	elseif self.displayDirection == "down" then
		self.y = knight.y + (self.height/2) + self.yRand
		self.x = knight.x - (self.width/4) + self.xRand
	elseif self.displayDirection == "left" then
		self.y = knight.y - (self.height/4) + self.yRand
		self.x = knight.x - self.width + self.xRand
	elseif self.displayDirection == "right" then
		self.y = knight.y - (self.height/4) + self.yRand
		self.x = knight.x + (self.width/2) + self.xRand
	end
	--]]
	
	local radius = 70
	self.x = knight.x + radius * math.cos(-self.displayAngle) - 16 + self.xRand
	self.y = knight.y + radius * math.sin(-self.displayAngle) - 32 + self.yRand
	
	
	self.timer = self.timer - 1
	if self.timer <= 0 then
		local toDelete
		for i,effect in pairs(knight.PROJECTILES) do
			if effect == self then
				toDelete = i
			end
		end
		table.remove(knight.PROJECTILES, toDelete)
	end
	
	
	--[[
	if self.beingUsed then
		self:attack()
		self.attackAnimation = self.attackAnimation  + 1
		if self.attackAnimation > 12 then
			self.attackAnimation = 1
			self.beingUsed = false
			self.enemiesHit = {}
		end
		
		if map:canMove(self, "up", 0) then
			return
		elseif map:canMove(self, "down", 0) then
			return
		elseif map:canMove(self, "left", 0) then
			return
		elseif map:canMove(self, "right", 0) then
			return
		else
			self.beingUsed = false
			knight.xSpeed = 5
		end
	end
	--]]
end

function Sword.attack(self)
	for i,enemy in pairs(map.enemies) do
		if self:collidesWith(enemy) and self.enemiesHit[enemy] == nil then
			enemy:damage()
			enemy:knockback(self)
			self.enemiesHit[enemy] = enemy
			--self.attackAnimation = 1
			--self.beingUsed = false
			
		end
	end
end
