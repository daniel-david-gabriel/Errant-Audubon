require("lua/sprites/sprite")
require("lua/images")

Spark = {}
Spark.__index = Spark


setmetatable(Spark, {
  __index = Effect,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Spark:_init(x, y, width, height)
	Sprite._init(self, x, y, width, height)

    self.spriteName = "Spark"
    
    self.x_speed = math.random()/2
    self.y_speed = math.random()

    self.x_dir = math.random(0, 1)
    self.y_dir = math.random(0, 1)
    
    
    self.spriteCounter = 1
	self.spriteTimer = 0
end

function Spark.draw(self)
    love.graphics.setColor(255, 255, 255, 255)
    
    local sprites = images:getImage(self.spriteName)
    
	love.graphics.draw(sprites["image"], sprites["quads"][self.spriteCounter], (self.x), (self.y))
end

function Spark.update(self, dt)

    dt = love.timer.getDelta()
	
	
    self.spriteTimer = self.spriteTimer + dt
	if self.spriteTimer > .1 then
		
		if self.spriteCounter == 2 then
			if math.random(0, 4) == 0 then
				self.spriteCounter = 5
			else
				self.spriteCounter = 3
			end
		elseif self.spriteCounter == 4 or self.spriteCounter == 6 then
        	self:despawn(map)
		else
			self.spriteCounter = self.spriteCounter + 1
		end
        
        self.spriteTimer = 0
    end
    
    if self.x_dir == 1 then 
        self.x = self.x + self.x_speed
    else 
        self.x = self.x - self.x_speed
    end
    
    self.y = self.y - self.y_speed
    
end

function Spark.despawn(self, map)
	local toDelete
	for i,effect in pairs(map.effects) do
		if effect == self then
			toDelete = i
		end
	end
	table.remove(map.effects, toDelete)
end
