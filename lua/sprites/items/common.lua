require("lua/sprites/item")

Common = {}
Common.__index = Common


setmetatable(Common, {
  __index = Item,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Common:_init(x, y, enemyName, imageName)
	Item._init(self, x, y, imageName)

	self.enemyName = enemyName
end

function Common.activate(self)
	knight.journal[self.enemyName]:addGoodCommon()
	knight.journal[self.enemyName]:addKill()
end
