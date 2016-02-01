require("lua/sprites/sprite")

Shopkeeper = {}
Shopkeeper.__index = Shopkeeper


setmetatable(Shopkeeper, {
  __index = Npc,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Shopkeeper:_init(x, y, width, height, name, portraitName, flag, dialog)
	Npc._init(self, x, y, width, height)

	self.flag = flag
	self.dialog = dialog
	self.portraitName = portraitName
	self.name = name
	--self.spriteName = spritename
end

function Shopkeeper.draw(self)
	love.graphics.setColor(0, 128, 255, 255)
	love.graphics.rectangle("fill", (self.x)-32, (self.y)-32, 32, 32)
end

function Shopkeeper.interact(self)
	local flagValue = knight.flags[self.flag]

	if not self.dialog[flagValue] then
		flagValue = 1
	end
	
	local items = {}
	
	items[1] = ShopItem("Claw", images:getImage("claw"), "This is a basic claw. Use it to claw things")
	items[2] = ShopItem("Sword", images:getImage("sword"), "A basic sword. It can be selected to the primary tool slot.")
	items[3] = ShopItem("Glove", images:getImage("glove"), "A grab glove! Inthe future this will be a dungeon item!")
	items[4] = ShopItem("Shield", images:getImage("shield"), "A basic shield. Block basic attacks from the direction it's pointing.")

	game.shop:set(self.name, self.portraitName, self.dialog[flagValue], items)
end
