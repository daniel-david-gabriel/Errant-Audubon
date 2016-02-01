ShopItem = {}
ShopItem.__index = ShopItem

setmetatable(ShopItem, {
  __index = ShopItem,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function ShopItem:_init(name, icon, description)
	self.name = name
	self.icon = icon
	self.description = description
end

function ShopItem.buy(self)
	print( "Buying " .. self.name)
	return true
end