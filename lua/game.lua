require("lua/sprites/lootGenerator")
require("lua/sprites/knight")
require("lua/map/map")
require("lua/map/dialog")
require("lua/map/shopItem")
require("lua/map/shop")
require("lua/sprites/door")
require("lua/sprites/trigger")
require("lua/sprites/npc")
require("lua/sprites/shopkeeper")
require("lua/sprites/warp")

require("lua/sprites/puzzle/switch")
require("lua/sprites/puzzle/lock")
require("lua/sprites/puzzle/block")

require("lua/sprites/projectiles/arrow")
require("lua/sprites/projectiles/bullet")
require("lua/sprites/enemies/cannon")
require("lua/sprites/enemies/turret")
require("lua/sprites/enemies/archer")
require("lua/sprites/enemies/slime")
require("lua/sprites/enemies/minispider")
require("lua/sprites/enemies/blackbell")
require("lua/sprites/enemies/bigslime")
require("lua/sprites/enemies/bat")
require("lua/sprites/enemies/potSpider")
require("lua/sprites/enemies/amphora")
require("lua/sprites/enemies/chest")

Game = {}
Game.__index = Game

setmetatable(Game, {
  __index = Game,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Game:_init()
	knight = Knight()
	
	self.dialog = Dialog()
	self.shop = Shop()

	maps = self:loadMaps()
	--map = maps["Town-001"]
	map = maps["Field-003"]
	toMap = nil

	lootGenerator = LootGenerator()

	self.gameMenu = GameMenu()
end

function Game.draw(self)
	map:draw()
	if self.dialog:isSet() then
		self.dialog:draw()
	elseif self.shop:isSet() then
		self.shop:draw()
	end
end

function Game.keypressed(self, key)
	if key == keyBindings:getMenu() then
		toState = self.gameMenu
		knight:resetKeys()
		
	else
		if self.dialog:isSet() then
			self.dialog:keypressed(key)
		elseif self.shop:isSet() then
			self.shop:keypressed(key)
		else
			knight:keypressed(key)
		end
	end
end

function Game.keyreleased(self, key )
	knight:keyreleased(key)
end

function Game.mousepressed(self, x, y, button)
	--noop
end

function Game.update(self, dt)
	if toMap then
		map:reset()
		map = toMap
		toMap = nil
	end

	knight:update(dt)
	map:update(dt)

	if self.dialog:isSet() then
		self.dialog:update()
	elseif self.shop:isSet() then
		self.shop:update()
	end
end

function Game.loadMaps(self)
	local maps = {}

	local mapFiles = love.filesystem.getDirectoryItems("media/maps")
	for _,file in pairs(mapFiles) do
		maps[file] = Map(file)
	end

	return maps
end

function Game.load(self, save)
	knight = save:load()
	--set map as well?
end
