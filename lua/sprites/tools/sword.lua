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
	Sprite._init(self, 0, 0, 32, 32)

	self.imageName = "sword"
	self.name = "sword weapon"

	self.beingUsed = false
	self.attackAnimation = 1
	self.facingDirection = "down"
	self.enemiesHit = {}
end

function Sword.use(self, knight)
	self.beingUsed = true

	self.x = knight.x
	self.y = knight.y
	self.facingDirection = knight.displayDirection
    --[[
	if knight.displayDirection == "up" then
		self.y = self.y - 32
	elseif knight.displayDirection == "down" then
		self.y = self.y + 32
	elseif knight.displayDirection == "left" then
		self.x = self.x - 32
	elseif knight.displayDirection == "right" then
		self.x = self.x + 32
	end
    --]]
    
    positions = {}
    
    down = {}
    down["x"] = {30, -10, -30, -33, 0}
    down["y"] = {19, 22, 11, -20, 36}
    up = {}
    up["x"] = {-30, -10, 30, 33, 0}
    up["y"] = {-24, -32, -21, -10, -44}
    left = {}
    left["x"] = {-20, -30, -20, 0, -42}
    left["y"] = {11, -18, -30, -35, 0}
    right = {}
    right["x"] = {20, 30, 20, 0, 42}
    right["y"] = {11, -18, -30, -35, 0}
    
    positions["down"] = down
    positions["up"] = up
    positions["left"] = left
    positions["right"] = right
    
    if knight.STATE == "TOOL_USE" then
        if knight.tool_timer >= knight.tool_timer_max*(2/3) + 2 and knight.tool_timer <= knight.tool_timer_max then
            self.x = self.x + positions[self.facingDirection]["x"][1]
            self.y = self.y + positions[self.facingDirection]["y"][1]
        elseif knight.tool_timer >= (knight.tool_timer_max/3) + 2 and knight.tool_timer < knight.tool_timer_max*(2/3) + 2 then
            self.x = self.x + positions[self.facingDirection]["x"][2]
            self.y = self.y + positions[self.facingDirection]["y"][2]
        elseif knight.tool_timer > 0 and knight.tool_timer < (knight.tool_timer_max/3) + 2 then
            self.x = self.x + positions[self.facingDirection]["x"][3]
            self.y = self.y + positions[self.facingDirection]["y"][3]
        end
    else
        if knight.STATE == "SWORD_SLASH" then
            self.x = self.x + positions[self.facingDirection]["x"][5]
            self.y = self.y + positions[self.facingDirection]["y"][5]
        elseif knight.freeze_direction == true and knight.tool_timer == 0 then
            self.x = self.x + positions[self.facingDirection]["x"][4]
            self.y = self.y + positions[self.facingDirection]["y"][4]
        end
    end
    
    if knight.HOP_OFFSET >= 0 then
		self.y = self.y - knight.HOP_OFFSET
    end
end

function Sword.draw(self)
	
	if options.debug and self.beingUsed then
		love.graphics.setColor(0, 255, 0, 128)
		love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	end

	if self.beingUsed then
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
end

function Sword.update(self, dt)
	if self.beingUsed then
		self:attack()
		self.attackAnimation = self.attackAnimation  + 1
		if self.attackAnimation > 12 then
			self.attackAnimation = 1
			self.beingUsed = false
			self.enemiesHit = {}
		end
	end
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
