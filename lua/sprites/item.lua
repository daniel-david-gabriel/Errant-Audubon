require("lua/sprites/sprite")

Item = {}
Item.__index = Item


setmetatable(Item, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Item:_init(x, y, imageName)
	Sprite._init(self, x, y, 16, 16)

	self.imageName = imageName
	self.yOffset = 16
	self.bounce = false
end

function Item.draw(self)
	local image = images:getImage(self.imageName)

	love.graphics.setColor(0, 0, 0, 96)
	love.graphics.circle( "fill", self.x-24, (self.y)-24, 8, 50 )

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(image, (self.x)-32, (self.y)-32-self.yOffset)
end

function Item.update(self, map, dt)
	if self:collidesWith(knight) then
		self:activate()
		self:despawn(map)
	end
	if self.yOffset > 0 then
		self.yOffset = self.yOffset - 4
	elseif not self.bounce then
		self.bounce = true
		self.yOffset = self.yOffset + 8
	end
end

function Item.despawn(self, map)
	local toDelete
	for i,item in pairs(map.items) do
		if item == self then
			toDelete = i
		end
	end
	table.remove(map.items, toDelete)
end
