require("lua/tileset")

Tiles = {}
Tiles.__index = Tiles


setmetatable(Tiles, {
  __index = Tiles,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Tiles:_init()
	self.tilesets = {}

	self.tilesets["field"] = self:loadTileset("field", 512, 416)
	self.tilesets["field"]:addPlayerTiles({"1", "46", "47", "49", "50", "53", "65", "67", "68", "69", "78", "82", "85", "94",
	"100", "101", "102", "103", "104", "105", "106", "116", "117", "118", "119", "120", "121", "122", "132", "133", "134", "135",
	"136", "137", "148", "149", "150", "151", "164", "165", "166", "167"})
	self.tilesets["field"]:addEnemyTiles({"1", "49", "50", "53", "65", "67", "68", "69", "78", "82", "85", "94", "100", "101",
	"102", "103", "104", "105", "106", "116", "117", "118", "119", "120", "121", "122", "132", "133", "134", "135", "136", "137",
	"148", "149", "150", "151", "164", "165", "166", "167"})

	self.tilesets["town"] = self:loadTileset("town", 512, 448)
	self.tilesets["town"]:addPlayerTiles({"1", "65", "67", "72", "81", "83", "88", "97", "98", "99", "100", "101", "104", "105",
	"120", "121", "129", "130", "131", "132", "133", "134", "135", "136", "137", "145", "146", "147", "148", "153", "161", "162",
	"163", "180"})
	
	self.tilesets["interior"] = self:loadTileset("interior", 512, 448)
	self.tilesets["interior"]:addPlayerTiles({"51", "52", "53", "58", "67", "68", "83", "84", "89", "90", "99", "100", "105", "106", "114"})
	
	self.tilesets["cave"] = self:loadTileset("cave", 512, 448)
	self.tilesets["cave"]:addPlayerTiles({"1", "99", "100", "101", "102", "113", "116", "117"})
	self.tilesets["cave"]:addEnemyTiles({"1", "113"})
end

function Tiles.getTileSet(self, tileset)
	return self.tilesets[tileset].tileset
end

function Tiles.getTile(self, tileset, tileNumber)
	return self.tilesets[tileset].tiles[tonumber(tileNumber)]
end

function Tiles.getPlayerTiles(self, tileset)
	return self.tilesets[tileset].playerTiles
end

function Tiles.getEnemyTiles(self, tileset)
	return self.tilesets[tileset].enemyTiles
end

function Tiles.loadTileset(self, name, width, height)

	local tileset = love.graphics.newImage("media/tiles/" .. name .. ".png")
	local tiles = {}

	local tileWidth = 32
	local tileHeight = 32
	local x = 0
	local y = 0
	local i = 1
	local total = (width/32) * (height/32)

	for i=1,total do
		tiles[i] = love.graphics.newQuad(x, y, tileWidth, tileHeight, width, height)

		x = x + tileWidth
		if x >= width then
			x = 0
			y = y + tileHeight
		end
	end

	return Tileset(tileset, tiles)
end
