require("lua/sprites/sprite")
require("lua/images")

AttackHit = {}
AttackHit.__index = AttackHit


setmetatable(AttackHit, {
  __index = Effect,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function AttackHit:_init(x, y, width, height)
	Sprite._init(self, x, y, width, height)

    self.spriteName = "attackHit"
    
    self.x_speed = math.random()/2
    self.y_speed = math.random()/2

    self.x_dir = math.random(0, 1)
    self.y_dir = math.random(0, 1)
    
    
    self.spriteCounter = 1
	self.spriteTimer = 0
end

function AttackHit.draw(self)
    love.graphics.setColor(255, 255, 255, 255)
    local sprites = images:getImage(self.spriteName)
    if self.spriteCounter <= 6 then
        love.graphics.draw(sprites["image"], sprites["quads"]["up"][self.spriteCounter], (self.x), (self.y)-16)
    else
        love.graphics.draw(sprites["image"], sprites["quads"]["up"][1], (self.x), (self.y))
    end
end

function AttackHit.update(self, dt)
    dt = love.timer.getDelta()
    self.spriteTimer = self.spriteTimer + dt
	if self.spriteTimer > .02 then
        if self.spriteCounter < 7 then
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
    
    
    if self.spriteCounter >= 7 then
        self:despawn(map)
    end
end

function AttackHit.despawn(self, map)
	local toDelete
	for i,effect in pairs(map.effects) do
		if effect == self then
			toDelete = i
		end
	end
	table.remove(map.effects, toDelete)
end
