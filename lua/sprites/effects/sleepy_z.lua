require("lua/sprites/sprite")
require("lua/images")

SleepyZ = {}
SleepyZ.__index = SleepyZ


setmetatable(SleepyZ, {
  __index = Effect,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function SleepyZ:_init(x, y, width, height)
	Sprite._init(self, x, y, width, height)

    self.spriteName = "SleepyZ"
    
    self.x_speed = math.random()/2
    self.y_speed = math.random()
    
    self.spriteCounter = 1
	self.spriteTimer = 0
end

function SleepyZ.draw(self)
    love.graphics.setColor(255, 255, 255, 255)
    local sprites = images:getImage(self.spriteName)
    if self.spriteCounter <= 4 then
        love.graphics.draw(sprites["image"], sprites["quads"]["down"][self.spriteCounter], (self.x), (self.y))
    end
end

function SleepyZ.update(self, dt)
    dt = love.timer.getDelta()
    self.spriteTimer = self.spriteTimer + dt
	if self.spriteTimer > .5 then
        if self.spriteCounter < 5 then
            self.spriteCounter = self.spriteCounter + 1
        end
        
        self.spriteTimer = 0
    end
    
    self.x = self.x + self.x_speed
    self.y = self.y - self.y_speed
    
    
    if self.spriteCounter >= 5 then
    	self:despawn(map)
    end
    
end

function SleepyZ.despawn(self, map)
	local toDelete
	for i,effect in pairs(map.effects) do
		if effect == self then
			toDelete = i
		end
	end
	table.remove(map.effects, toDelete)
end