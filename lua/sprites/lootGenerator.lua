require("lua/sprites/item")
require("lua/sprites/items/heart")
require("lua/sprites/items/diamond")
require("lua/sprites/items/common")
require("lua/sprites/items/uncommon")
require("lua/sprites/items/rare")

LootGenerator = {}
LootGenerator.__index = LootGenerator


setmetatable(LootGenerator, {
  __index = LootGenerator,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function LootGenerator:_init()
	self.sfx = "item"
end

function LootGenerator.generate(self, enemy)
	--fix. Probably not a good random
	local roll = math.random(100)
	local x = enemy.x
	local y = enemy.y
	--print(roll)
	if roll < 10 then
		table.insert(map.items, Heart(x, y))
		soundEffects:playSoundEffect(self.sfx)
	elseif roll < 60 then
		table.insert(map.items, Diamond(x, y))
		soundEffects:playSoundEffect(self.sfx)
	elseif roll < 70 then
		--nothing!
	elseif roll < 85 then
		table.insert(map.items, Common(x, y, enemy.name, enemy.common))
		soundEffects:playSoundEffect(self.sfx)
	elseif roll < 95 then
		table.insert(map.items, Uncommon(x, y, enemy.name, enemy.uncommon))
		soundEffects:playSoundEffect(self.sfx)
	else
		table.insert(map.items, Rare(x, y, enemy.name, enemy.rare))
		soundEffects:playSoundEffect(self.sfx)
	end
end
