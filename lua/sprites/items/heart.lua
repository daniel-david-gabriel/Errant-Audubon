require("lua/sprites/item")

Heart = {}
Heart.__index = Heart


setmetatable(Heart, {
  __index = Item,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Heart:_init(x, y)
	Item._init(self, x, y, "heart", "")
end

function Heart.activate(self)
	knight:heal(25)
end
