require("lua/sprites/enemy")

Amphora = {}
Amphora.__index = Amphora


setmetatable(Amphora, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Amphora:_init(x, y, mode)
	Enemy._init(self, x, y, 32, 32, "small", 1, "slimeball", "eye", "diamond")

	self.name = "amphora"
	self.mode = mode
end

function Amphora.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(images:getImage("amphora"), (self.x)-32, (self.y)-64)
	
end

function Amphora.update(self, map, dt)
	if knight.isGrabbing and knight.grabbedEnemy == self then
		self.x = knight.x - 16
		self.y = knight.y - 16
		return
	end

end

function Amphora.damage(self)
	if self.mode == "unsafe" then
		--spawn 2 minispiders
		local minispider1 = Minispider(self.x+(self.width/2), self.y+(self.height/2))
		local minispider2 = Minispider(self.x+(self.width/2), self.y+(self.height/2))
		
		table.insert(map.enemies, minispider1)
		table.insert(map.enemies, minispider2)
	end
	
	Enemy.despawn(self, map)
end