require("lua/sprites/enemy")

Chest = {}
Chest.__index = Chest


setmetatable(Chest, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Chest:_init(x, y, item)
	Enemy._init(self, x, y, 32, 32, "medium", 1, "slimeball", "eye", "diamond")

	self.name = "chest"
	self.item = item
end

function Chest.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(images:getImage("chest"), (self.x)-32, (self.y)-32)
	
end

function Chest.update(self, map, dt)
	--
end

function Chest.damage(self)

	--spawn self.item
	if self.item == "Diamond" then
		local loot = Diamond(self.x + (self.width/2), self.y + (self.height/2))
		table.insert(map.items, loot)
	elseif self.item == "Heart" then
		local loot = Heart(self.x + (self.width/2), self.y + (self.height/2))
		table.insert(map.items, loot)
	end
	
	Enemy.despawn(self, map)
end