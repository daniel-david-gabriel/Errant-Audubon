require("lua/sprites/enemy")

require("lua/sprites/effects/sleepy_z")
Slime = {}
Slime.__index = Slime


setmetatable(Slime, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Slime:_init(x, y, init_state)
	Enemy._init(self, x, y, 32, 32, "small", 1, "slimeball", "eye", "diamond")

	self.moveTimer = 0
	self.spriteCounter = 1
    self.spriteTimer = 0 
	
	self.z_timer = 0
	
	self.speed = 1
	self.direction = "down"
	--self.sprites = images:getImage("slime")
	self.name = "slime"
    
    self.STATE = init_state
    self.SPEED_THING = 0
end

function Slime.draw(self)

	love.graphics.setColor(255, 255, 255, 255)
	local sprites = images:getImage(self.name)
    if self.STATE == "sleep" then
        if self.spriteCounter >= 3 then
            self.spriteCounter = 1
        end
        love.graphics.draw(sprites["image"], sprites["quads"]["sleep"..self.direction][self.spriteCounter], (self.x)-32, (self.y)-32)
    else
        love.graphics.draw(sprites["image"], sprites["quads"][self.direction][self.spriteCounter], (self.x)-32, (self.y)-32)
    end
    
    --love.graphics.print(self.STATE, 300, 180)
    --love.graphics.print(self.moveTimer, 300, 180)
    
end

function Slime.update(self, map, dt)
    
	if knight.isGrabbing and knight.grabbedEnemy == self then
		self.x = knight.x - 16
		self.y = knight.y - 16

		self.spriteCounter = 1
		return
	end

	if self:collidesWith(knight) then
		knight:knockback(self, 5)
	end


    
    if not (self.STATE == "sleep") then
        self.moveTimer = self.moveTimer + dt
        self:move(self.direction, self.speed)
        self.spriteTimer = self.spriteTimer + dt
        if self.spriteTimer > .2 then
            self.spriteCounter = self.spriteCounter + 1
            self.spriteTimer = 0
            
            if self.spriteCounter > 5 then
                self.spriteCounter = 1
            end
        end
    end
    
    if self.STATE == "STATE_ONE" then
        self.direction = "down"
        if self.moveTimer > 2 then
            self.STATE = "STATE_TWO"
            self.moveTimer = 0
            return
        end
    end
    if self.STATE == "STATE_TWO" then
        self.direction = "right"
        if self.moveTimer > 2 then
            self.STATE = "STATE_THREE"
            self.moveTimer = 0
            return
        end
    end
    if self.STATE == "STATE_THREE" then
        self.direction = "up"
        if self.moveTimer > 2 then
            self.STATE = "STATE_FOUR"
            self.moveTimer = 0
            return
        end
    end
    if self.STATE == "STATE_FOUR" then
        self.direction = "left"
        if self.moveTimer > 2 then
            self.STATE = "STATE_ONE"
            self.moveTimer = 0
            return
        end
    end
    
    if self:isInRange(knight) then
        if self.STATE == "sleep" then
           self.STATE =  "STATE_ONE"
        end
    end
    
    if self.STATE == "sleep" then
        self.spriteTimer = self.spriteTimer + dt
        if self.spriteTimer > .8 then
            self.spriteCounter = self.spriteCounter + 1
            self.spriteTimer = 0
            
            if self.spriteCounter > 2 then
                self.spriteCounter = 1
            end
        end
        
        if self.z_timer > 120 then
        	self.z_timer = 0
            table.insert(map.effects, SleepyZ(self.x-8, self.y-32))
        else
        	self.z_timer = self.z_timer + 1
        end
        return
    end
    
    --[[
    if self.STATE == "approach_player" then
        self.moveTimer = self.moveTimer + dt
        if self.moveTimer < 0.25 then
            return
        end
        self.moveTimer = 0
        

        if self:isLeftOf(knight) then
            self:move("right", self.speed)
        elseif self:isRightOf(knight) then
            self:move("left", self.speed)
        elseif self:isAbove(knight) then
            self:move("down", self.speed)
            self.direction = "down"
        elseif self:isBelow(knight) then
            self:move("up", self.speed)
            self.direction = "up"
        end
        
        return
    end
    --]]
end

function Slime.isInRange(self, enemy)
	local xWithinRange = math.abs(self.x - enemy.x) < 100
	local yWithinRange = math.abs(self.y - enemy.y) < 100

	return (xWithinRange and yWithinRange)
end
