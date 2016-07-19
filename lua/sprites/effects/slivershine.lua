require("lua/sprites/sprite")
require("lua/images")

SliverShine = {}
SliverShine.__index = SliverShine


setmetatable(SliverShine, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function SliverShine:_init(x, y)
	Sprite._init(self, x, y, 32, 32)

	self.spriteName = "SliverShine"
	
	self.spriteCounter = 2
	if math.random(2) == 1 then
		self.spriteCounter = 6
	end
	self.spriteTimer = 0
	
end

function SliverShine.draw(self)
    love.graphics.setColor(255, 255, 255, 255)
    local sprites = images:getImage(self.spriteName)
	love.graphics.draw(sprites["image"], sprites["quads"][self.spriteCounter], self.x-16, self.y-16)
	
end

function SliverShine.update(self, dt)
	if self.spriteTimer >= 5 then
		if self.spriteCounter == 5 or  self.spriteCounter == 9 then
			self:despawn(map)
		end
		self.spriteTimer = 0
		self.spriteCounter = self.spriteCounter + 1
	else
		self.spriteTimer = self.spriteTimer + 1
	end
    
end

function SliverShine.despawn(self, map)
	local toDelete
	for i,effect in pairs(map.effects) do
		if effect == self then
			toDelete = i
		end
	end
	table.remove(map.effects, toDelete)
end
