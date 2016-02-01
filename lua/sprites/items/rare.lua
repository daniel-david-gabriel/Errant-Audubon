require("lua/sprites/item")

Rare = {}
Rare.__index = Rare


setmetatable(Rare, {
  __index = Item,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Rare:_init(x, y, enemyName, imageName)
	Item._init(self, x, y, imageName)

	self.enemyName = enemyName
end

function Rare.activate(self)
	knight.journal[self.enemyName]:addGoodRare()
	knight.journal[self.enemyName]:addKill()
end
