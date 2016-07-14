require("lua/sprites/sprite")
require("lua/images")

Smoke = {}
Smoke.__index = Smoke


setmetatable(Smoke, {
  __index = Effect,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Smoke:_init(x, y, width, height)
	Sprite._init(self, x, y, width, height)

    self.spriteName = "Smoke"
    
    self.x_speed = math.random()*(2/3)
    self.y_speed = math.random()*(2/3)

    self.x_dir = math.random(0, 1)
    self.y_dir = math.random(0, 1)
    
    
    self.spriteCounter = 1
	self.spriteTimer = 0
	
	self.spriteTimerRAND = math.random(7)/100
	
	self.kind = 1
	if math.random(4) == 1 then
		self.kind = 2
	end
end

function Smoke.draw(self)
    love.graphics.setColor(255, 255, 255, 255)
    local sprites = images:getImage(self.spriteName)
    if self.spriteCounter <= 11 then
        love.graphics.draw(sprites["image"], sprites["quads"][self.kind][self.spriteCounter], (self.x)-32, (self.y)-32)
    else
        love.graphics.draw(sprites["image"], sprites["quads"][1][1], (self.x), (self.y))
    end
end

function Smoke.update(self, dt)
    dt = love.timer.getDelta()
    self.spriteTimer = self.spriteTimer + dt
	if self.spriteTimer > self.spriteTimerRAND then
        if self.spriteCounter < 12 then
            self.spriteCounter = self.spriteCounter + 1
        end
        
        self.spriteTimer = 0
    end
    
    if self.x_dir == 1 then 
        self.x = self.x + self.x_speed
    else 
        self.x = self.x - self.x_speed
    end
    
    if self.y_dir == 0 then 
        self.y = self.y + self.y_speed
    else
        self.y = self.y - self.y_speed
    end
    
    
    if self.spriteCounter >= 12 then
        self:despawn(map)
    end
end

function Smoke.despawn(self, map)
	local toDelete
	for i,effect in pairs(map.effects) do
		if effect == self then
			toDelete = i
		end
	end
	table.remove(map.effects, toDelete)
end
