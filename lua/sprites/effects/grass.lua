require("lua/sprites/sprite")
require("lua/images")

Grass = {}
Grass.__index = Grass


setmetatable(Grass, {
  __index = Effect,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Grass:_init(x, y, width, height)
	Sprite._init(self, x, y, width, height)

    self.spriteName = "Grass"
    
    self.x_speed = math.random()/2
    self.y_speed = math.random()/2

    self.x_dir = math.random(0, 1)
    self.y_dir = math.random(0, 1)
    
    
    self.spriteCounter = 1
	self.spriteTimer = 0
	
	self.frameTimer = math.random()*80 
end

function Grass.draw(self)
    love.graphics.setColor(255, 255, 255, 255)
    local sprites = images:getImage(self.spriteName)
	love.graphics.draw(sprites["image"], sprites["quads"][self.spriteCounter], self.x-32, self.y-64)
end

function Grass.update(self, dt)
    self.spriteTimer = self.spriteTimer + 0.25
	if self.spriteTimer > self.frameTimer then
        self.spriteCounter = math.random(4)
        self.spriteTimer = 0
    end
    
    
    if self.spriteCounter >= 10 then
        --self:despawn(map)
    end
end

function Grass.despawn(self, map)
	local toDelete
	for i,effect in pairs(map.effects) do
		if effect == self then
			toDelete = i
		end
	end
	table.remove(map.effects, toDelete)
end
