require("lua/sprites/sprite")
require("lua/images")

Dust = {}
Dust.__index = Dust


setmetatable(Dust, {
  __index = Effect,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Dust:_init(x, y, width, height)
	Sprite._init(self, x, y, width, height)

    self.spriteName = "dust"
    
    self.x_speed = math.random()/2
    self.y_speed = math.random()/2

    self.x_dir = math.random(0, 1)
    self.y_dir = math.random(0, 1)
    
    self.red = 0
    self.green = 0
    self.blue = 0
    
    self.hue = 148
    self.saturation = 186
    self.value = 230
    
    self.spriteCounter = 1
	self.spriteTimer = 0
end

function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h, s, v = h/256*6, s/255, v/255
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255
end

function Dust.draw(self)
    --[[
    if self.hue > 0 then
    	self.hue = self.hue - 10
    end
    if self.hue > 100 then
    	self.hue = self.hue - 1
    end
    
    self.red, self.green, self.blue = HSV(self.hue, self.saturation, self.value)
    love.graphics.setColor(self.red, self.green, self.blue, 255)
    --]]
    love.graphics.setColor(255, 255, 255, 255)
    
    local sprites = images:getImage(self.spriteName)
    if self.spriteCounter <= 9 then
        love.graphics.draw(sprites["image"], sprites["quads"]["down"][self.spriteCounter], (self.x), (self.y)-16)
    else
        love.graphics.draw(sprites["image"], sprites["quads"]["down"][1], (self.x), (self.y))
    end
end

function Dust.update(self, dt)
    dt = love.timer.getDelta()
    self.spriteTimer = self.spriteTimer + dt
	if self.spriteTimer > .04 then
        if self.spriteCounter < 10 then
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
    
    
    if self.spriteCounter >= 10 then
        self:despawn(map)
    end
end

function Dust.despawn(self, map)
	local toDelete
	for i,effect in pairs(map.effects) do
		if effect == self then
			toDelete = i
		end
	end
	table.remove(map.effects, toDelete)
end
