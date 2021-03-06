require("lua/utils")
require("lua/persistence/persistence")

Map = {}
Map.__index = Map

setmetatable(Map, {
  __index = Persistence,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Map:_init(mapName)
	Persistence._init(self, "media/maps/" .. mapName)

	self.mapName = mapName

	self.tileset = self:loadTileset(mapName)
	self.background = self:loadBackground(mapName)
	self.foreground = self:loadForeground(mapName)
	self.enemies = self:loadEnemies(mapName)
	self.doors = self:loadDoors(mapName)
	self.npcs = self:loadNpcs(mapName)
	self.shopkeepers = self:loadShopkeepers(mapName)
	self.triggers = self:loadTriggers(mapName)
	--self.cinemas = self:loadCinemas(mapName)
	self.puzzles = self:loadPuzzles(mapName)
	self.locks = self:loadLocks(mapName)
	
	self.bgm = self:loadBGM(mapName)
	
	self.title = self:loadTitle(mapName)
	self.displayTimer = false
	self.titleTimer = 0

	self.bullets = {}
	self.items = {}
	self.effects = {}
end

function Map.loadTitle(self, mapName)
	if not love.filesystem.getInfo("media/maps/" .. mapName .. "/title") then
		return ""
	end

	local title = love.filesystem.read("media/maps/" .. mapName .. "/title")
	return title
end

function Map.loadTileset(self, mapName)
	local tilesetData = love.filesystem.lines("media/maps/" .. mapName .. "/tileset")
	for line in tilesetData do
		return line
	end
end

function Map.loadBackground(self, mapName)
	local mapData = love.filesystem.lines( "media/maps/" .. mapName .. "/map" )
	local background = {}
	local x = 1
	local y = 1
	for line in mapData do
		background[y] = {}
		x = 1
		-- string.match?
		for tile in string.gmatch (line, "%d+") do
  			background[y][x] = tile
			x = x + 1
		end
		y = y +1
	end

	return background
end

function Map.loadForeground(self, mapName)
	if not love.filesystem.getInfo("media/maps/" .. mapName .. "/foreground") then
		return {}
	end

	local mapData = love.filesystem.lines( "media/maps/" .. mapName .. "/foreground" )
	local foreground = {}
	local x = 1
	local y = 1
	for line in mapData do
		foreground[y] = {}
		x = 1
		-- string.match?
		for tile in string.gmatch (line, "%d+") do
  			foreground[y][x] = tile
			x = x + 1
		end
		y = y +1
	end

	return foreground
end

function Map.loadEnemies(self, mapName)
	if not love.filesystem.getInfo("media/maps/" .. mapName .. "/enemies") then
		return {}
	end

	local enemyData = love.filesystem.lines( "media/maps/" .. mapName .. "/enemies" )
	local enemies = {}

	for line in enemyData do
		local enemyProperties = split(line, "%S+")
		-- switch on name for class?
		local enemy = self:createEnemy(enemyProperties)
		table.insert(enemies, enemy)
	end

	return enemies
end

function Map.createEnemy(self, enemyProperties)
	local enemy

	if enemyProperties[1] == "Cannon" then
		enemy = Cannon(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32)
	elseif enemyProperties[1] == "Archer" then
		enemy = Archer(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32)
	elseif enemyProperties[1] == "Turret" then
		enemy = Turret(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32)	
	elseif enemyProperties[1] == "Slime" then
		enemy = Slime(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32, enemyProperties[4])
	elseif enemyProperties[1] == "Minispider" then
		enemy = Minispider(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32)
	elseif enemyProperties[1] == "BlackBell" then
		enemy = BlackBell(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32)
	elseif enemyProperties[1] == "Bigslime" then
		enemy = Bigslime(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32)
	elseif enemyProperties[1] == "Bat" then
		enemy = Bat(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32)
	elseif enemyProperties[1] == "PotSpider" then
		enemy = PotSpider(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32)
	elseif enemyProperties[1] == "Porol" then
		enemy = Porol(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32, enemyProperties[4])
	elseif enemyProperties[1] == "Dummy" then
		enemy = Dummy(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32)
	elseif enemyProperties[1] == "Aurin" then
		enemy = Aurin(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32)
	elseif enemyProperties[1] == "Furotis" then
		enemy = Furotis(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32)
	elseif enemyProperties[1] == "Fireball" then
		enemy = Fireball(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32)
	elseif enemyProperties[1] == "Vine" then
		enemy = Vine(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32, tonumber(enemyProperties[4]), tonumber(enemyProperties[5]))
	elseif enemyProperties[1] == "WallSpider" then
		enemy = WallSpider(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32)

	--Breakable Items
	elseif enemyProperties[1] == "Amphora" then
		enemy = Amphora(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32, enemyProperties[4])
	elseif enemyProperties[1] == "Chest" then
		enemy = Chest(tonumber(enemyProperties[2])*32, tonumber(enemyProperties[3])*32, enemyProperties[4])
	end

	return enemy
end

function Map.loadDoors(self, mapName)
	if not love.filesystem.getInfo("media/maps/" .. mapName .. "/doors") then
		return {}
	end

	local doorData = love.filesystem.lines( "media/maps/" .. mapName .. "/doors" )
	local doors = {}

	for line in doorData do
		local doorProperties = split(line, "%S+")
		if doorProperties[1] == "Warp" then
			local warp = Warp(tonumber(doorProperties[2])*32, tonumber(doorProperties[3])*32, doorProperties[4], doorProperties[5], doorProperties[6])
			table.insert(doors, warp)
		else
			local door = Door(tonumber(doorProperties[2])*32, tonumber(doorProperties[3])*32, doorProperties[4], doorProperties[5], doorProperties[6])
			table.insert(doors, door)
		end
	end

	return doors
end

function Map.loadNpcs(self, mapName)
	if not love.filesystem.getInfo("media/maps/" .. mapName .. "/npcs") then
		return {}
	end

	local npcData = love.filesystem.lines( "media/maps/" .. mapName .. "/npcs" )
	local npcs = {}

	for line in npcData do
		local npcProperties = split(line, "[^\t]+")
		local name = npcProperties[1]
		local x = tonumber(npcProperties[2])*32
		local y = tonumber(npcProperties[3])*32
		local portrait = npcProperties[4]
		local flag = npcProperties[5]
		local dialog = {}
		local value = 1
		for i=6,table.getn(npcProperties) do
			local dialogString = npcProperties[i]
			if string.find(dialogString, "=") then
				local flagProperties = split(dialogString, "[^=]+")
				value = tonumber(flagProperties[2])
				dialog[value] = {}
			else
				table.insert(dialog[value], dialogString)
			end
		end
		local npc = Npc(x, y, 32, 32, name, portrait, flag, dialog)
		table.insert(npcs, npc)
	end

	return npcs
end

function Map.loadShopkeepers(self, mapName)
	if not love.filesystem.getInfo("media/maps/" .. mapName .. "/shopkeepers") then
		return {}
	end

	local shopKeeperData = love.filesystem.lines( "media/maps/" .. mapName .. "/shopkeepers" )
	local shopKeepers = {}

	for line in shopKeeperData do
		local npcProperties = split(line, "[^\t]+")
		local name = npcProperties[1]
		local x = tonumber(npcProperties[2])*32
		local y = tonumber(npcProperties[3])*32
		local portrait = npcProperties[4]
		local flag = npcProperties[5]
		local dialog = {}
		local value = 1
		for i=6,table.getn(npcProperties) do
			local dialogString = npcProperties[i]
			if string.find(dialogString, "=") then
				local flagProperties = split(dialogString, "[^=]+")
				value = tonumber(flagProperties[2])
				dialog[value] = {}
			else
				table.insert(dialog[value], dialogString)
			end
		end
		local npc = Shopkeeper(x, y, 32, 32, name, portrait, flag, dialog)
		table.insert(shopKeepers, npc)
	end

	return shopKeepers
end

function Map.loadTriggers(self, mapName)
	if not love.filesystem.getInfo("media/maps/" .. mapName .. "/triggers") then
		return {}
	end

	local triggerData = love.filesystem.lines( "media/maps/" .. mapName .. "/triggers" )
	local triggers = {}

	for line in triggerData do
		local triggerProperties = split(line, "%S+")

		local x = tonumber(triggerProperties[2])*32
		local y = tonumber(triggerProperties[3])*32
		local name = triggerProperties[4]
		local value = tonumber(triggerProperties[5])
		table.insert(triggers, Trigger(x, y, name, value))
	end

	return triggers
end

function Map.loadPuzzles(self, mapName)
	if not love.filesystem.getInfo("media/maps/" .. mapName .. "/puzzles") then
		return {}
	end

	local puzzleData = love.filesystem.lines( "media/maps/" .. mapName .. "/puzzles" )
	local puzzles = {}
	
	for line in puzzleData do
		local puzzleProperties = split(line, "%S+")
		
		if puzzleProperties[1] == "Switch" then
			local x = tonumber(puzzleProperties[2])*32
			local y = tonumber(puzzleProperties[3])*32
			local type = puzzleProperties[4]
			local lock = puzzleProperties[5]
			table.insert(puzzles, Switch(x, y, type, lock))
		elseif puzzleProperties[1] == "Block" then
			local x = tonumber(puzzleProperties[2])*32
			local y = tonumber(puzzleProperties[3])*32
			table.insert(puzzles, Block(x, y))
		end
	end
	
	return puzzles
end

function Map.loadLocks(self, mapName)
	if not love.filesystem.getInfo("media/maps/" .. mapName .. "/locks") then
		return {}
	end

	local lockData = love.filesystem.lines( "media/maps/" .. mapName .. "/locks" )
	local locks = {}
	
	for line in lockData do
		local lockProperties = split(line, "%S+")

		local x = tonumber(lockProperties[2])*32
		local y = tonumber(lockProperties[3])*32
		local name = lockProperties[4]
		table.insert(locks, Lock(x, y, name))
	end
	
	return locks
end

function Map.loadBGM(self, mapName)
	if not love.filesystem.getInfo("media/maps/" .. mapName .. "/bgm") then
		return ""
	end
	
	local bgmData = love.filesystem.lines( "media/maps/" .. mapName .. "/bgm" )
	for line in bgmData do
		return line
	end
end

function Map.removeLock(self, lockName)
	local toDelete
	for i,lock in pairs(map.locks) do
		if lock.name == lockName then
			toDelete = i
		end
	end
	table.remove(map.locks, toDelete)
end

function insertionSort(array)
    local len = #array
    local j
    for j = 2, len do
        local key = array[j]
        local i = j - 1
        while i > 0 and array[i].y > key.y do
            array[i + 1] = array[i]
            i = i - 1
        end
        array[i + 1] = key
    end
    return array
end

function Map.draw(self)

	love.graphics.push()
	
    --love.graphics.setShader(shader)
    --shader:send("screen", {love.graphics.getWidth(), love.graphics.getHeight()})
    
	local temp = false
	
	if knight.STATE == "WALL_CLING" then
		temp = true
	end
	
	-- camera --
	if knight.displayDirection == "down" then
		if temp then
			camera.dest_x = knight.x - 16
			camera.dest_y = knight.y + 204
		else
			camera.dest_x = knight.x - 16
			camera.dest_y = knight.y + 64
		end
	elseif knight.displayDirection == "up" then
		if temp then
			camera.dest_x = knight.x - 16
			camera.dest_y = knight.y - 204
		else
			camera.dest_x = knight.x - 16
			camera.dest_y = knight.y - 64
		end
	elseif knight.displayDirection == "left" then
		if temp then
			camera.dest_x = knight.x - 236
			camera.dest_y = knight.y - 16
		else
			camera.dest_x = knight.x - 96
			camera.dest_y = knight.y - 16
		end
	else
		if temp then
			camera.dest_x = knight.x + 236
			camera.dest_y = knight.y - 16
		else
			camera.dest_x = knight.x + 96
			camera.dest_y = knight.y - 16
		end
	end
	
	local map_height = table.getn(self.background)*32
	local map_width = table.getn(self.background[1])*32
	if camera.dest_x < 400 then
		camera.dest_x = 400
	end
	if camera.dest_x > map_width - 400 then
		camera.dest_x = map_width - 400
	end
	if camera.dest_y < 300 then
		camera.dest_y = 300
	end
	if camera.dest_y > map_height - 300 then
		camera.dest_y = map_height - 300
	end
	
	local move_percent = 0.05
	
	camera.x = camera.x + move_percent*(camera.dest_x - camera.x)
	camera.y = camera.y + move_percent*(camera.dest_y - camera.y)
	
	-- earthquake effect
	if camera.quake_duration > 0 then
		camera.quake_duration = camera.quake_duration - 1
		camera.x = camera.x + math.floor((math.random()*12)-6)
		camera.y = camera.y + math.floor((math.random()*12)-6)
		if camera.x < 400 then
			camera.x = 400
		end
		if camera.x > map_width - 400 then
			camera.x = map_width - 400
		end
		if camera.y < 300 then
			camera.y = 300
		end
		if camera.y > map_height - 300 then
			camera.y = map_height - 300
		end
	end
	
	love.graphics.translate(-math.floor(camera.x-400), -math.floor(camera.y-300))
	-- ------ --
	
	local map_height = table.getn(self.background)
	local map_width = table.getn(self.background[1])
	local camera_top_corner_x = math.floor((camera.x - 400)/32)
	local camera_top_corner_y = math.floor((camera.y - 300)/32)
	local x = camera_top_corner_x*32
	local y = camera_top_corner_y*32
	
	local a = 19
	local b = 25
	
	if map_height >= 20 then
		a = 20
	end
	if map_width >= 26 then
		b = 26
	end
	
	for i=camera_top_corner_y+1, camera_top_corner_y + a do
		for j=camera_top_corner_x+1, camera_top_corner_x + b do
			self:paintTile(x, y, self.background[i][j])
			x = x + 32
		end
		x = camera_top_corner_x*32
		y = y + 32
	end
	
    love.graphics.setShader()

	for i,bullet in pairs(self.bullets) do
		bullet:draw()
	end

	for i,item in pairs(self.items) do
		item:draw()
	end
	
	--for i,effect in pairs(self.effects) do
	--	effect:draw()
	--end
	
	--for i,enemy in pairs(self.enemies) do
	--	enemy:draw()
	--end

	for i,npc in pairs(self.npcs) do
		npc:draw()
	end
	
	for i,shopkeeper in pairs(self.shopkeepers) do
		shopkeeper:draw()
	end
	--REMOVE
	for i,trigger in pairs(self.triggers) do
		trigger:draw()
	end
	for i,door in pairs(self.doors) do
		door:draw()
	end
	for i,puzzle in pairs(self.puzzles) do
		puzzle:draw()
	end
	for i,lock in pairs(self.locks) do
		lock:draw()
	end
	
	--knight:draw()
	
	-- --- DRAW ARRAY --- --
	draw_array = {}
	
	for n,enemy in pairs(self.enemies) do
		if enemy.x > camera.x - 400 - 32 and enemy.x < camera.x + 400 + 32 and
		   enemy.y > camera.y - 300 - 32 and enemy.y < camera.y + 300 + 64 then
			table.insert(draw_array, enemy)
		end
	end
	for i,effect in pairs(self.effects) do
		if effect.x > camera.x - 400 - 32 and effect.x < camera.x + 400 + 32 and
		   effect.y > camera.y - 300 - 32 and effect.y < camera.y + 300 + 32 then
			table.insert(draw_array, effect)
		end
	end
	
	table.insert(draw_array, knight)
	
	draw_array = insertionSort(draw_array)
	
	
	for i in pairs(draw_array) do
		draw_array[i]:draw()
	end
	-- --- ---- ----- --- --
	
	--[[
	x = 0
	y = 0
	for i,row in pairs(self.foreground) do
		for j,tile in pairs(row) do
			if not (tile == "1") then
				if x <= (math.floor(camera.x/32)+screen_width)*32 and x >= (math.floor(camera.x/32)-screen_width)*32 and
				   y <= (math.floor(camera.y/32)+screen_height)*32 and y >= (math.floor(camera.y/32)-screen_height)*32 then
					self:paintTile(x, y, tile)
				end
			end
			x= x+32
		end
		x = 0
		y = y+32
	end
	--]]
	
	love.graphics.pop()
	
	if self.displayTitle then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print(self.title, 250, 10)
	end
	
end

function Map.update(self, dt)
	if self.bgm ~= "" then
		music:playMusic(self.bgm)
	end

	if (self.titleTimer < 1) and (string.len(self.title) > 0) then
		self.titleTimer = self.titleTimer + dt
		self.displayTitle = true
	else
		self.displayTitle = false
	end
	
	for i,bullet in pairs(self.bullets) do
		bullet:update(self, dt)
	end
	for i,effect in pairs(self.effects) do
		effect:update(self, dt)
	end
	for i,enemy in pairs(self.enemies) do
		-- only update enemies that are on screen?
		--if enemy.x > camera.x - 400 - 32 and enemy.x < camera.x + 400 + 32 and
		--   enemy.y > camera.y - 300 - 32 and enemy.y < camera.y + 300 + 32 then
			enemy:update(self, dt)
		--end
	end
	for i,item in pairs(self.items) do
		item:update(self, dt)
	end
	for i,trigger in pairs(self.triggers) do
		trigger:update(self, dt)
	end
	for i,door in pairs(self.doors) do
		door:update(dt)
	end
	for i,puzzle in pairs(self.puzzles) do
		puzzle:update(dt)
	end
	for i,lock in pairs(self.locks) do
		lock:update(dt)
	end
end

function Map.paintTile(self, x, y, tile)
	love.graphics.setColor(255, 255, 255, 255) --probably should take from a map-based color scheme or theme
	love.graphics.draw(tiles:getTileSet(self.tileset), tiles:getTile(self.tileset, tile), x, y)
end

function Map.canMove(self, sprite, direction, speed)
	local map_height = table.getn(self.background)*32 - 16
	local map_width = table.getn(self.background[1])*32 - 16
	
	local validTiles = {}
	if sprite == knight then
		validTiles = tiles:getPlayerTiles(self.tileset)
	else
		validTiles = tiles:getEnemyTiles(self.tileset)
	end
	
	local xPos, xPos2, yPos, yPos2
	if direction == "up" then
		xPos = math.floor((sprite.x + 4) / 32)
		xPos2 = math.floor((sprite.x+28) / 32)
		yPos = math.floor((sprite.y+4-speed) / 32)
		yPos2 = yPos
	elseif direction == "down" then
		xPos = math.floor((sprite.x+4) / 32)
		xPos2 = math.floor((sprite.x+28) / 32)
		yPos = math.floor((sprite.y+28+speed) / 32)
		yPos2 = yPos
	elseif direction == "left" then
		xPos = math.floor((sprite.x+4-speed) / 32)
		xPos2 = xPos
		yPos = math.floor((sprite.y+4) / 32)
		yPos2 = math.floor((sprite.y+28) / 32)
	elseif direction == "right" then
		xPos = math.floor((sprite.x+28+speed) / 32)
		xPos2 = xPos
		yPos = math.floor((sprite.y+4) / 32)
		yPos2 = math.floor((sprite.y+28) / 32)
	end
	
	if xPos <= 0 or xPos > table.getn(self.background[1]) or yPos <= 0 or yPos > table.getn(self.background) then
		return false
	end
	
	
	local box1Valid = false
	for k,v in pairs(validTiles) do
		if self.background[yPos][xPos] == v then
			box1Valid = true
		end
	end
	
	local box2Valid = false
	for k,v in pairs(validTiles) do
		if self.background[yPos2][xPos2] == v then
			box2Valid = true
		end
	end

	return (box1Valid and box2Valid)
end

function Map.reset(self)
	-- file io on every map load? Probably a better way to do this.
	self.enemies = self:loadEnemies(self.mapName)
	self.doors = self:loadDoors(self.mapName)
	self.npcs = self:loadNpcs(self.mapName)
	self.triggers = self:loadTriggers(self.mapName)
	self.puzzles = self:loadPuzzles(self.mapName)
	self.locks = self:loadLocks(self.mapName)
	self.titleTimer = 0

	self.bullets = {}
	self.items = {}
end