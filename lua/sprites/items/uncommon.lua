require("lua/sprites/item")

Uncommon = {}
Uncommon.__index = Uncommon


setmetatable(Uncommon, {
  __index = Item,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Uncommon:_init(x, y, enemyName, imageName)
	Item._init(self, x, y, imageName)

	self.enemyName = enemyName
end

function Uncommon.activate(self)
	knight.journal[self.enemyName]:addGoodUncommon()
	knight.journal[self.enemyName]:addKill()
end
