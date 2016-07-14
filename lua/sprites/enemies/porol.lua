require("lua/sprites/enemy")

Porol = {}
Porol.__index = Porol


setmetatable(Porol, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Porol:_init(x, y, init_state)
	Enemy._init(self, x, y, 32, 32, "small", 3, "claw", "eye", "tuft")

	self.moveTimer = 0
	self.spriteCounter = 1
    self.spriteTimer = 0
	self.speed = 6

	self.state = init_state
	self.waitingTimer = 0
	self.direction  = "down"
    
    self.standTimer = 0
    self.walkTimer = 0

	self.spriteName = "porol"
	self.name = "porol"
end

function Porol.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	local sprites = images:getImage(self.spriteName)
	if self.state == "stand" then
		love.graphics.draw(sprites["image"], sprites["quads"][self.direction][1], (self.x)-32, (self.y)-64)
	elseif self.state == "look_around" then
        if self.spriteCounter >= 5 then
            self.spriteTimer = 0
            self.spriteCounter = 4
            self.state = "stand"
        end
		love.graphics.draw(sprites["image"], sprites["quads"]["look"..self.direction][self.spriteCounter], (self.x)-32, (self.y)-64)
	elseif self.state == "walk_a_little" then
        if self.spriteCounter >= 5 then
            self.spriteCounter = 1
        end
		love.graphics.draw(sprites["image"], sprites["quads"][self.direction][self.spriteCounter], (self.x)-32, (self.y)-64)
	end
    
	--[[
    love.graphics.print((self.state), 500, 180)
	love.graphics.print((self.standTimer), 500, 194)
	love.graphics.print((self.waitingTimer), 500, 208)
	love.graphics.print((self.walkTimer), 500, 222)
    --]]
end

function Porol.update(self, map, dt)
	if knight.isGrabbing and knight.grabbedEnemy == self then
		self.x = knight.x - 16
		self.y = knight.y - 16

		self.spriteCounter = 1
		return
	end

	if self:collidesWith(knight) then
		knight:knockback(self, 5)
	end
    
    if self.state == "stand" then
        self.standTimer = self.standTimer + 1
        if self.standTimer >= 100 then
            local rando = math.random(1000)
            if rando <= 5 then
                self.state = "look_around"
                self.standTimer = 0
                self.spriteTimer = 0
                self.spriteCounter = 1
                return
           elseif rando <= 11 and rando > 5 then
                local rand_dir = math.random(4)
                if rand_dir == 1 then
                    self.direction = "down"
                elseif rand_dir == 2 then
                    self.direction = "left"
                elseif rand_dir == 3 then
                    self.direction = "up"
                elseif rand_dir == 4 then
                    self.direction = "right"
                end
                self.state = "walk_a_little"
                self.standTimer = 0
                self.spriteTimer = 0
                self.spriteCounter = 1
                return
           end
           return
        end
    end
    
    self.spriteTimer = self.spriteTimer + dt
    if self.state == "look_around" then
        if self.spriteTimer > 1 then
            --[[if self.spriteCounter > 4 then
                self.state = "stand"
                self.spriteCounter = 1
            end--]]
            self.spriteCounter = self.spriteCounter + 1
            
            self.spriteTimer = 0
        end
    elseif self.state == "walk_a_little" then
        self.walkTimer = self.walkTimer + dt
        --self.walkTimer = self.walkTimer + 1
        if self.walkTimer > .8 then
           self.walkTimer = 0
           self.spriteTimer = 0
           self.state = "stand" 
        end
        
        self:move(self.direction, 1);
        if self.spriteTimer > .3 then
            if self.spriteCounter > 4 then
                self.spriteCounter = 1
            end
            self.spriteCounter = self.spriteCounter + 1
            
            self.spriteTimer = 0
        end
    end
end

function Porol.isInRange(self, enemy)
	local xWithinRange = math.abs(self.x - enemy.x) < 96
	local yWithinRange = math.abs(self.y - enemy.y) < 96

	return (xWithinRange and yWithinRange)
end
