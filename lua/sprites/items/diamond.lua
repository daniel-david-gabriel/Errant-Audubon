require("lua/sprites/item")

Diamond = {}
Diamond.__index = Diamond


setmetatable(Diamond, {
  __index = Item,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Diamond:_init(x, y)
	Item._init(self, x, y, "coin", "")
end

function Diamond.activate(self)
	knight.money = knight.money + 50
end
