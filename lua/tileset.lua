Tileset = {}
Tileset.__index = Tileset


setmetatable(Tileset, {
  __index = Tileset,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Tileset:_init(tileset, tiles)
	self.tileset = tileset
	self.tiles = tiles
	self.playerTiles = {}
	self.enemyTiles = {}
end

function Tileset.addPlayerTiles(self, tiles)
	for k,tile in pairs(tiles) do
		table.insert(self.playerTiles, tile)
	end
end

function Tileset.addEnemyTiles(self, tiles)
	for k,tile in pairs(tiles) do
		table.insert(self.enemyTiles, tile)
	end
end
