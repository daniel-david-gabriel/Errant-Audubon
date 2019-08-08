require("lua/sprites/sprite")
require("lua/images")

Book = {}
Book.__index = Book


setmetatable(Book, {
  __index = Effect,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Book:_init(x, y, other)
	Sprite._init(self, x, y, 16, 16)
	
	self.other = other
	
    self.spriteName = "Book"
    
    self.spriteCounter = 1
	self.spriteTimer = 0
	
	self.float_offset = 30
end

function Book.draw(self)
    love.graphics.setColor(255, 255, 255, 255)
    
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle("fill", self.x-8, self.y-8-self.float_offset, 16, 16)
	love.graphics.setColor(0, 100, 100, 128)
	love.graphics.ellipse("fill", self.x, self.y, 6, 3)
    --[[
    local sprites = images:getImage(self.spriteName)
    
    if self.spriteCounter <= 9 then
        love.graphics.draw(sprites["image"], sprites["quads"]["down"][self.spriteCounter], (self.x), (self.y)-16)
    else
        love.graphics.draw(sprites["image"], sprites["quads"]["down"][1], (self.x), (self.y))
    end
    --]]
end

function Book.update(self, dt)
    if self.spriteTimer > math.pi*2 then
    	self.spriteTimer = 0
    else
    	self.spriteTimer = self.spriteTimer + math.pi*(1/100)
    end
    
    self.x = self.other.x - 16 + math.cos(self.spriteTimer)*32
    self.y = self.other.y + math.sin(self.spriteTimer)*24
    
    self.float_offset = 30 - (math.sin(self.spriteTimer/2))*10
    
    if self.other.health <= 0 then
        self:despawn(map)
    end
end

function Book.despawn(self, map)
	local toDelete
	for i,effect in pairs(map.effects) do
		if effect == self then
			toDelete = i
		end
	end
	table.remove(map.effects, toDelete)
end
