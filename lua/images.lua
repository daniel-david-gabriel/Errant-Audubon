Images = {}
Images.__index = Images


setmetatable(Images, {
  __index = Images,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Images:_init()
	self.images = {}
    
	self.images["dust"] = self:loadDust()
	self.images["SleepyZ"] = self:loadSleepyZ()
	self.images["Spark"] = self:loadSpark()
	self.images["Grass"] = self:loadGrass()
	self.images["Smoke"] = self:loadSmoke()
	self.images["Sliver"] = self:loadSliver()
	self.images["SliverShine"] = self:loadSliver()
	self.images["Dummy"] = self:loadDummy()

	self.images["bullet"] = love.graphics.newImage("media/sprites/bullet.png")
	self.images["arrow"] = love.graphics.newImage("media/sprites/arrow.png")
	self.images["archer"] = love.graphics.newImage("media/sprites/archer.png")
	self.images["turret"] = love.graphics.newImage("media/sprites/turret.png")

	self.images["blackbell"] = self:loadEnemySprites("blackbell")
	self.images["slime"] = self:loadSlime()
	self.images["minispider"] = self:loadMinispider()
	self.images["bigslime"] = self:loadBigslime()
	self.images["bat"] = self:loadBat()
	self.images["potSpider"] = self:loadPotSpider()
	self.images["porol"] = self:loadPorol()
	self.images["aurin"] = self:loadAurin()
	self.images["Furotis"] = self:loadFurotis()
	self.images["Fireball"] = self:loadFireball()
	self.images["Vine"] = self:loadVine()
	

	self.images["heart"] = love.graphics.newImage("media/sprites/items/heart.png")
	self.images["diamond"] = love.graphics.newImage("media/sprites/items/diamond.png")
	self.images["coin"] = love.graphics.newImage("media/sprites/items/coin.png")
	self.images["common"] = love.graphics.newImage("media/sprites/items/common.png")
	self.images["uncommon"] = love.graphics.newImage("media/sprites/items/uncommon.png")
	self.images["rare"] = love.graphics.newImage("media/sprites/items/rare.png")

	self.images["claw"] = love.graphics.newImage("media/sprites/items/claw.png")
	self.images["eye"] = love.graphics.newImage("media/sprites/items/eye.png")
	self.images["feather"] = love.graphics.newImage("media/sprites/items/feather.png")
	self.images["tuft"] = love.graphics.newImage("media/sprites/items/tuft.png")
	self.images["slimeball"] = love.graphics.newImage("media/sprites/items/slime.png")
	
	self.images["sword"] = love.graphics.newImage("media/menu/tools/sword.png")
	self.images["sword"]:setFilter("nearest", "nearest")
	self.images["glove"] = love.graphics.newImage("media/menu/tools/glove.png")
	self.images["shield"] = love.graphics.newImage("media/menu/tools/shield.png")
	
	self.images["sword weapon"] = self:loadSword()
	
	self.images["circle"] = love.graphics.newImage("media/sprites/circle.png")
	
	self.images["amphora"] = love.graphics.newImage("media/sprites/enemies/amphora.png")
	self.images["chest"] = love.graphics.newImage("media/sprites/enemies/chest.png")

	self.images["audubon"] = self:loadAudubon()
end

function Images.getImage(self, imageName)
	return self.images[imageName]
end

--[[
Load sprites into a table of tables.
--]]
function Images.loadEnemySprites(self, enemyName)


	local enemySprites = {}
	local i = 1

	-- front
	local frontSprites = {}
	while love.filesystem.exists("media/sprites/enemies/" .. enemyName .. "/Front-" .. tostring(i) .. ".png") do
		frontSprites[i] = love.graphics.newImage("media/sprites/enemies/" .. enemyName .. "/Front-" .. tostring(i) .. ".png")
		i = i + 1
	end
	enemySprites["front"] = frontSprites
	
	-- back
	i = 1
	local backSprites = {}
	while love.filesystem.exists("media/sprites/enemies/" .. enemyName .. "/Back-" .. tostring(i) .. ".png") do
		backSprites[i] = love.graphics.newImage("media/sprites/enemies/" .. enemyName .. "/Back-" .. tostring(i) .. ".png")
		i = i + 1
	end
	enemySprites["back"] = backSprites
	-- left

	-- right

	-- attack

	return enemySprites
end

function Images.loadMinispider(self)
	local sprites = {}
	sprites["image"] = love.graphics.newImage("media/sprites/enemies/minispider/sprites.png")

	local quads = {}
	local down = {}
	down[1] = love.graphics.newQuad(0, 0, 16, 16, 128, 16)
	down[2] = love.graphics.newQuad(16, 0, 16, 16, 128, 16)

	local up = {}
	up[1] = love.graphics.newQuad(32, 0, 16, 16, 128, 16)
	up[2] = love.graphics.newQuad(48, 0, 16, 16, 128, 16)

	local left = {}
	left[1] = love.graphics.newQuad(64, 0, 16, 16, 128, 16)
	left[2] = love.graphics.newQuad(80, 0, 16, 16, 128, 16)

	local right = {}
	right[1] = love.graphics.newQuad(96, 0, 16, 16, 128, 16)
	right[2] = love.graphics.newQuad(112, 0, 16, 16, 128, 16)

	quads["down"] = down
	quads["up"] = up
	quads["left"] = left
	quads["right"] = right

	sprites["quads"] = quads

	return sprites
end

function Images.loadBat(self)
	local sprites = {}
	sprites["image"] = love.graphics.newImage("media/sprites/enemies/bat.png")

	local quads = {}
	quads[1] = love.graphics.newQuad(0, 0, 64, 32, 64, 128)
	quads[2] = love.graphics.newQuad(0, 32, 64, 32, 64, 128)
	quads[3] = love.graphics.newQuad(0, 64, 64, 32, 64, 128)
	quads[4] = love.graphics.newQuad(0, 96, 64, 32, 64, 128)
	quads[5] = love.graphics.newQuad(0, 64, 64, 32, 64, 128)
	quads[6] = love.graphics.newQuad(0, 32, 64, 32, 64, 128)

	sprites["quads"] = quads

	return sprites
end

function Images.loadPotSpider()
	local sprites = {}
	sprites["image"] = love.graphics.newImage("media/sprites/enemies/potSpider.png")
	sprites["image"]:setFilter("nearest", "nearest")

	local quads = {}
	local standDown = {}
	standDown[1] = love.graphics.newQuad(0, 0, 32, 64, 192, 256)
	standDown[2] = love.graphics.newQuad(32, 0, 32, 64, 192, 256)
	
	local down = {}
	down[1] = love.graphics.newQuad(64, 0, 32, 64, 192, 256)
	down[2] = love.graphics.newQuad(96, 0, 32, 64, 192, 256)
	down[3] = love.graphics.newQuad(128, 0, 32, 64, 192, 256)
	
	local sleepDown = {}
	sleepDown[1] = love.graphics.newQuad(160, 0, 32, 64, 192, 256)
	
	quads["standdown"] = standDown
	quads["down"] = down
	quads["sleepdown"] = sleepDown
	
	local standUp = {}
	standUp[1] = love.graphics.newQuad(0, 64, 32, 64, 192, 256)
	standUp[2] = love.graphics.newQuad(32, 64, 32, 64, 192, 256)
	
	local up = {}
	up[1] = love.graphics.newQuad(64, 64, 32, 64, 192, 256)
	up[2] = love.graphics.newQuad(96, 64, 32, 64, 192, 256)
	up[3] = love.graphics.newQuad(128, 64, 32, 64, 192, 256)
	
	local sleepUp = {}
	sleepUp[1] = love.graphics.newQuad(160, 64, 32, 64, 192, 256)
	
	quads["standup"] = standUp
	quads["up"] = up
	quads["sleepup"] = sleepUp
	
	local standLeft = {}
	standLeft[1] = love.graphics.newQuad(0, 128, 32, 64, 192, 256)
	standLeft[2] = love.graphics.newQuad(32, 128, 32, 64, 192, 256)
	
	local left = {}
	left[1] = love.graphics.newQuad(64, 128, 32, 64, 192, 256)
	left[2] = love.graphics.newQuad(96, 128, 32, 64, 192, 256)
	left[3] = love.graphics.newQuad(128, 128, 32, 64, 192, 256)
	
	local sleepLeft = {}
	sleepLeft[1] = love.graphics.newQuad(160, 128, 32, 64, 192, 256)
	
	quads["standleft"] = standLeft
	quads["left"] = left
	quads["sleepleft"] = sleepLeft
	
	local standRight = {}
	standRight[1] = love.graphics.newQuad(0, 192, 32, 64, 192, 256)
	standRight[2] = love.graphics.newQuad(32, 192, 32, 64, 192, 256)
	
	local right = {}
	right[1] = love.graphics.newQuad(64, 192, 32, 64, 192, 256)
	right[2] = love.graphics.newQuad(96, 192, 32, 64, 192, 256)
	right[3] = love.graphics.newQuad(128, 192, 32, 64, 192, 256)
	
	local sleepRight = {}
	sleepRight[1] = love.graphics.newQuad(160, 192, 32, 64, 192, 256)
	
	quads["standright"] = standRight
	quads["right"] = right
	quads["sleepright"] = sleepRight
	
	sprites["quads"] = quads
	
	return sprites
end

function Images.loadPorol()
	local sprites = {}
	sprites["image"] = love.graphics.newImage("media/sprites/enemies/porol.png")

	local quads = {}
	
	local down = {}
	down[1] = love.graphics.newQuad(0, 0, 32, 64, 160, 256)
	down[2] = love.graphics.newQuad(32, 0, 32, 64, 160, 256)
	down[3] = love.graphics.newQuad(0, 0, 32, 64, 160, 256)
	down[4] = love.graphics.newQuad(64, 0, 32, 64, 160, 256)
	
	quads["down"] = down
	
	local up = {}
	up[1] = love.graphics.newQuad(0, 128, 32, 64, 160, 256)
	up[2] = love.graphics.newQuad(32, 128, 32, 64, 160, 256)
	up[3] = love.graphics.newQuad(0, 128, 32, 64, 160, 256)
	up[4] = love.graphics.newQuad(64, 128, 32, 64, 160, 256)
	
	quads["up"] = up

	local left = {}
	left[1] = love.graphics.newQuad(0, 64, 32, 64, 160, 256)
	left[2] = love.graphics.newQuad(32, 64, 32, 64, 160, 256)
	left[3] = love.graphics.newQuad(0, 64, 32, 64, 160, 256)
	left[4] = love.graphics.newQuad(64, 64, 32, 64, 160, 256)
    
	quads["left"] = left
	
	local right = {}
	right[1] = love.graphics.newQuad(0, 192, 32, 64, 160, 256)
	right[2] = love.graphics.newQuad(32, 192, 32, 64, 160, 256)
	right[3] = love.graphics.newQuad(0, 192, 32, 64, 160, 256)
	right[4] = love.graphics.newQuad(64, 192, 32, 64, 160, 256)
	
	quads["right"] = right
	
    local lookDown = {}
    lookDown[1] = love.graphics.newQuad(96, 0, 32, 64, 160, 256)
	lookDown[2] = love.graphics.newQuad(0, 0, 32, 64, 160, 256)
    lookDown[3] = love.graphics.newQuad(128, 0, 32, 64, 160, 256)
	lookDown[4] = love.graphics.newQuad(0, 0, 32, 64, 160, 256)
    
    quads["lookdown"] = lookDown
    
    local lookLeft = {}
    lookLeft[1] = love.graphics.newQuad(96, 64, 32, 64, 160, 256)
	lookLeft[2] = love.graphics.newQuad(0, 64, 32, 64, 160, 256)
    lookLeft[3] = love.graphics.newQuad(128, 64, 32, 64, 160, 256)
	lookLeft[4] = love.graphics.newQuad(0, 64, 32, 64, 160, 256)
    
    quads["lookleft"] = lookLeft
    
    local lookUp = {}
    lookUp[1] = love.graphics.newQuad(96, 128, 32, 64, 160, 256)
	lookUp[2] = love.graphics.newQuad(0, 128, 32, 64, 160, 256)
    lookUp[3] = love.graphics.newQuad(128, 128, 32, 64, 160, 256)
	lookUp[4] = love.graphics.newQuad(0, 128, 32, 64, 160, 256)
    
    quads["lookup"] = lookUp
    
    local lookRight = {}
    lookRight[1] = love.graphics.newQuad(96, 192, 32, 64, 160, 256)
	lookRight[2] = love.graphics.newQuad(0, 192, 32, 64, 160, 256)
    lookRight[3] = love.graphics.newQuad(128, 192, 32, 64, 160, 256)
	lookRight[4] = love.graphics.newQuad(0, 192, 32, 64, 160, 256)
    
    quads["lookright"] = lookRight
    
	sprites["quads"] = quads
	
	return sprites
end

function Images.loadAurin()
  local sprites = {}
  sprites["image"] = love.graphics.newImage("media/sprites/enemies/Aurin.png")
  sprites["image"]:setFilter("nearest", "nearest")

  local quads = {}
  
  local down = {}
  down[1] = love.graphics.newQuad(0, 0, 32, 32, 64, 128)
  --down[2] = love.graphics.newQuad(32, 0, 32, 64, 160, 256)
  --down[3] = love.graphics.newQuad(0, 0, 32, 64, 160, 256)
  --down[4] = love.graphics.newQuad(64, 0, 32, 64, 160, 256)
  
  local up = {}
  up[1] = love.graphics.newQuad(0, 32, 32, 32, 64, 128)
  
  local left = {}
  left[1] = love.graphics.newQuad(0, 64, 32, 32, 64, 128)
  
  local right = {}
  right[1] = love.graphics.newQuad(0, 96, 32, 32, 64, 128)
  
  local slide = {}
  local slidedown = {}
  local slideup = {}
  local slideleft = {}
  local slideright = {}
  
  slidedown[1] = love.graphics.newQuad(32, 0, 32, 32, 64, 128)
  slideup[1] = love.graphics.newQuad(32, 32, 32, 32, 64, 128)
  slideleft[1] = love.graphics.newQuad(32, 64, 32, 32, 64, 128)
  slideright[1] = love.graphics.newQuad(32, 96, 32, 32, 64, 128)
  slide["down"] = slidedown
  slide["up"] = slideup
  slide["left"] = slideleft
  slide["right"] = slideright
  
  quads["down"] = down
  quads["up"] = up
  quads["left"] = left
  quads["right"] = right
  quads["slide"] = slide
  sprites["quads"] = quads
  
  return sprites
end

function Images.loadFurotis()
	local sprites = {}
	sprites["image"] = love.graphics.newImage("media/sprites/enemies/Furotis.png")

	local quads = {}
	
	local down = {}
	down[1] = love.graphics.newQuad(0, 0, 32, 64, 96, 256)
	down[2] = love.graphics.newQuad(32, 0, 32, 64, 96, 256)
	down[3] = love.graphics.newQuad(64, 0, 32, 64, 96, 256)
	
	quads["down"] = down
	
	local up = {}
	up[1] = love.graphics.newQuad(0, 64, 32, 64, 96, 256)
	up[2] = love.graphics.newQuad(32, 64, 32, 64, 96, 256)
	up[3] = love.graphics.newQuad(64, 64, 32, 64, 96, 256)
	
	quads["up"] = up

	local left = {}
    
	quads["left"] = left
	left[1] = love.graphics.newQuad(0, 128, 32, 64, 96, 256)
	left[2] = love.graphics.newQuad(32, 128, 32, 64, 96, 256)
	left[3] = love.graphics.newQuad(64, 128, 32, 64, 96, 256)
	
	local right = {}
	right[1] = love.graphics.newQuad(0, 192, 32, 64, 96, 256)
	right[2] = love.graphics.newQuad(32, 192, 32, 64, 96, 256)
	right[3] = love.graphics.newQuad(64, 192, 32, 64, 96, 256)
	
	quads["right"] = right
	sprites["quads"] = quads
	
	return sprites
end

function Images.loadFireball()
	local sprites = {}
	sprites["image"] = love.graphics.newImage("media/sprites/enemies/fireball.png")
    sprites["image"]:setFilter("nearest", "nearest")
	
	local quads = {}
	quads[1] = love.graphics.newQuad(0, 0, 32, 32, 64, 32)
	quads[2] = love.graphics.newQuad(32, 0, 32, 32, 64, 32)
	
	sprites["quads"] = quads
	
	return sprites
end

function Images.loadVine()
	local sprites = {}
	sprites["image"] = love.graphics.newImage("media/sprites/enemies/vine.png")
    sprites["image"]:setFilter("nearest", "nearest")
	
	local quads = {}
	quads[1] = love.graphics.newQuad(0, 0, 32, 32, 64, 32)
	quads[2] = love.graphics.newQuad(32, 0, 32, 32, 64, 32)
	
	sprites["quads"] = quads
	
	return sprites
end

function Images.loadSlime()
	local sprites = {}
	sprites["image"] = love.graphics.newImage("media/sprites/enemies/slime.png")
    sprites["image"]:setFilter("nearest", "nearest")

	local quads = {}
	
	local down = {}
	down[1] = love.graphics.newQuad(0, 0, 32, 32, 224, 128)
	down[2] = love.graphics.newQuad(32, 0, 32, 32, 224, 128)
	down[3] = love.graphics.newQuad(64, 0, 32, 32, 224, 128)
	down[4] = love.graphics.newQuad(96, 0, 32, 32, 224, 128)
	down[5] = love.graphics.newQuad(128, 0, 32, 32, 224, 128)
	
	quads["down"] = down
	
	local up = {}
	up[1] = love.graphics.newQuad(0, 32, 32, 32, 224, 128)
	up[2] = love.graphics.newQuad(32, 32, 32, 32, 224, 128)
	up[3] = love.graphics.newQuad(64, 32, 32, 32, 224, 128)
	up[4] = love.graphics.newQuad(96, 32, 32, 32, 224, 128)
	up[5] = love.graphics.newQuad(128, 32, 32, 32, 224, 128)
	
	quads["up"] = up

	local left = {}
	left[1] = love.graphics.newQuad(0, 64, 32, 32, 224, 128)
	left[2] = love.graphics.newQuad(32, 64, 32, 32, 224, 128)
	left[3] = love.graphics.newQuad(64, 64, 32, 32, 224, 128)
	left[4] = love.graphics.newQuad(96, 64, 32, 32, 224, 128)
	left[5] = love.graphics.newQuad(128, 64, 32, 32, 224, 128)
    
	quads["left"] = left
	
	local right = {}
	right[1] = love.graphics.newQuad(0, 96, 32, 32, 224, 128)
	right[2] = love.graphics.newQuad(32, 96, 32, 32, 224, 128)
	right[3] = love.graphics.newQuad(64, 96, 32, 32, 224, 128)
	right[4] = love.graphics.newQuad(96, 96, 32, 32, 224, 128)
	right[5] = love.graphics.newQuad(128, 96, 32, 32, 224, 128)
	
	quads["right"] = right
	
    local sleepDown = {}
    sleepDown[1] = love.graphics.newQuad(160, 0, 32, 32, 224, 128)
	sleepDown[2] = love.graphics.newQuad(192, 0, 32, 32, 224, 128)
    
    quads["sleepdown"] = sleepDown
    
    local sleepLeft = {}
    sleepLeft[1] = love.graphics.newQuad(160, 32, 32, 32, 224, 128)
	sleepLeft[2] = love.graphics.newQuad(192, 32, 32, 32, 224, 128)
    
    quads["sleepleft"] = sleepLeft
    
    local sleepUp = {}
    sleepUp[1] = love.graphics.newQuad(160, 64, 32, 32, 224, 128)
	sleepUp[2] = love.graphics.newQuad(192, 64, 32, 32, 224, 128)
    
    quads["sleepup"] = sleepUp
    
    local sleepRight = {}
    sleepRight[1] = love.graphics.newQuad(160, 96, 32, 32, 224, 128)
	sleepRight[2] = love.graphics.newQuad(192, 96, 32, 32, 224, 128)
    
    quads["sleep"] = sleepRight
    
	sprites["quads"] = quads
	
	return sprites
end

function Images.loadBigslime()
	local sprites = {}
	sprites["image"] = love.graphics.newImage("media/sprites/enemies/bigslime.png")
    sprites["image"]:setFilter("nearest", "nearest")

	local quads = {}
	
	local down = {}
	down[1] = love.graphics.newQuad(0, 0, 64, 64, 576, 256)
	down[2] = love.graphics.newQuad(64, 0, 64, 64, 576, 256)
	down[3] = love.graphics.newQuad(128, 0, 64, 64, 576, 256)
	down[4] = love.graphics.newQuad(192, 0, 64, 64, 576, 256)
	down[5] = love.graphics.newQuad(256, 0, 64, 64, 576, 256)
	
	local up = {}
	up[1] = love.graphics.newQuad(0, 64, 64, 64, 576, 256)
	up[2] = love.graphics.newQuad(64, 64, 64, 64, 576, 256)
	up[3] = love.graphics.newQuad(128, 64, 64, 64, 576, 256)
	up[4] = love.graphics.newQuad(192, 64, 64, 64, 576, 256)
	up[5] = love.graphics.newQuad(256, 64, 64, 64, 576, 256)
	
	local left = {}
	left[1] = love.graphics.newQuad(0, 128, 64, 64, 576, 256)
	left[2] = love.graphics.newQuad(64, 128, 64, 64, 576, 256)
	left[3] = love.graphics.newQuad(128, 128, 64, 64, 576, 256)
	left[4] = love.graphics.newQuad(192, 128, 64, 64, 576, 256)
	left[5] = love.graphics.newQuad(256, 128, 64, 64, 576, 256)
    
	local right = {}
	right[1] = love.graphics.newQuad(0, 192, 64, 64, 576, 256)
	right[2] = love.graphics.newQuad(64, 192, 64, 64, 576, 256)
	right[3] = love.graphics.newQuad(128, 192, 64, 64, 576, 256)
	right[4] = love.graphics.newQuad(192, 192, 64, 64, 576, 256)
	right[5] = love.graphics.newQuad(256, 192, 64, 64, 576, 256)
	
	local jump_down = {}
	jump_down[1] = love.graphics.newQuad(320, 0, 64, 64, 576, 256)
	jump_down[2] = love.graphics.newQuad(384, 0, 64, 64, 576, 256)
	jump_down[3] = love.graphics.newQuad(448, 0, 64, 64, 576, 256)
	jump_down[4] = love.graphics.newQuad(512, 0, 64, 64, 576, 256)
	
	local jump = {}
	jump["down"] = jump_down
	jump["up"] = jump_down
	jump["right"] = jump_down
	jump["left"] = jump_down
	
	quads["jump"] = jump
	quads["down"] = down
	quads["up"] = up
	quads["left"] = left
	quads["right"] = right
    
	sprites["quads"] = quads
	
	return sprites
end

function Images.loadDust(self)
	local sprites = {}
    sprites["image"] = love.graphics.newImage("media/sprites/effects/dust.png")
    sprites["image"]:setFilter("nearest", "nearest")
    
    local quads = {}
    local down = {}
	down[1] = love.graphics.newQuad(0, 0, 16, 16, 144, 16)
	down[2] = love.graphics.newQuad(16, 0, 16, 16, 144, 16)
	down[3] = love.graphics.newQuad(32, 0, 16, 16, 144, 16)
	down[4] = love.graphics.newQuad(48, 0, 16, 16, 144, 16)
	down[5] = love.graphics.newQuad(64, 0, 16, 16, 144, 16)
	down[6] = love.graphics.newQuad(80, 0, 16, 16, 144, 16)
	down[7] = love.graphics.newQuad(96, 0, 16, 16, 144, 16)
	down[8] = love.graphics.newQuad(112, 0, 16, 16, 144, 16)
	down[9] = love.graphics.newQuad(128, 0, 16, 16, 144, 16)
    
    quads["down"] = down

	sprites["quads"] = quads

	return sprites
end

function Images.loadSleepyZ(self)
	local sprites = {}
    sprites["image"] = love.graphics.newImage("media/sprites/effects/z_effect.png")
	sprites["image"]:setFilter("nearest", "nearest")
    
    local quads = {}
    local down = {}
	down[1] = love.graphics.newQuad(0, 0, 16, 16, 64, 16)
	down[2] = love.graphics.newQuad(16, 0, 16, 16, 64, 16)
	down[3] = love.graphics.newQuad(32, 0, 16, 16, 64, 16)
	down[4] = love.graphics.newQuad(48, 0, 16, 16, 64, 16)
    
    quads["down"] = down

	sprites["quads"] = quads

	return sprites
end


function Images.loadSpark(self)
	local sprites = {}
    sprites["image"] = love.graphics.newImage("media/sprites/effects/fireballparticle.png")
    sprites["image"]:setFilter("nearest", "nearest")
    
    local quads = {}
	quads[1] = love.graphics.newQuad(0, 0, 8, 8, 48, 8)
	quads[2] = love.graphics.newQuad(8, 0, 8, 8, 48, 8)
	quads[3] = love.graphics.newQuad(16, 0, 8, 8, 48, 8)
	quads[4] = love.graphics.newQuad(24, 0, 8, 8, 48, 8)
	quads[5] = love.graphics.newQuad(32, 0, 8, 8, 48, 8)
	quads[6] = love.graphics.newQuad(40, 0, 8, 8, 48, 8)

	sprites["quads"] = quads

	return sprites
end

function Images.loadGrass(self)
	local sprites = {}
    sprites["image"] = love.graphics.newImage("media/sprites/effects/grass.png")
    sprites["image"]:setFilter("nearest", "nearest")
    
    local quads = {}
	quads[1] = love.graphics.newQuad(0, 0, 32, 64, 128, 64)
	quads[2] = love.graphics.newQuad(32, 0, 32, 64, 128, 64)
	quads[3] = love.graphics.newQuad(64, 0, 32, 64, 128, 64)
	quads[4] = love.graphics.newQuad(96, 0, 32, 64, 128, 64)
	sprites["quads"] = quads

	return sprites
end

function Images.loadSmoke(self)
	local sprites = {}
    sprites["image"] = love.graphics.newImage("media/sprites/effects/smoke.png")
    sprites["image"]:setFilter("nearest", "nearest")
    
    local quads = {}
    local one = {}
	one[1] = love.graphics.newQuad(0, 0, 32, 32, 352, 64)
	one[2] = love.graphics.newQuad(32, 0, 32, 32, 352, 64)
	one[3] = love.graphics.newQuad(64, 0, 32, 32, 352, 64)
	one[4] = love.graphics.newQuad(96, 0, 32, 32, 352, 64)
	one[5] = love.graphics.newQuad(128, 0, 32, 32, 352, 64)
	one[6] = love.graphics.newQuad(160, 0, 32, 32, 352, 64)
	one[7] = love.graphics.newQuad(192, 0, 32, 32, 352, 64)
	one[8] = love.graphics.newQuad(224, 0, 32, 32, 352, 64)
	one[9] = love.graphics.newQuad(256, 0, 32, 32, 352, 64)
	one[10] = love.graphics.newQuad(288, 0, 32, 32, 352, 64)
	one[11] = love.graphics.newQuad(320, 0, 32, 32, 352, 64)
    local two = {}
	two[1] = love.graphics.newQuad(0, 32, 32, 32, 352, 64)
	two[2] = love.graphics.newQuad(32, 32, 32, 32, 352, 64)
	two[3] = love.graphics.newQuad(64, 32, 32, 32, 352, 64)
	two[4] = love.graphics.newQuad(96, 32, 32, 32, 352, 64)
	two[5] = love.graphics.newQuad(128, 32, 32, 32, 352, 64)
	two[6] = love.graphics.newQuad(160, 32, 32, 32, 352, 64)
	two[7] = love.graphics.newQuad(192, 32, 32, 32, 352, 64)
	two[8] = love.graphics.newQuad(224, 32, 32, 32, 352, 64)
	two[9] = love.graphics.newQuad(256, 32, 32, 32, 352, 64)
	two[10] = love.graphics.newQuad(288, 32, 32, 32, 352, 64)
	two[11] = love.graphics.newQuad(320, 32, 32, 32, 352, 64)
    
    quads[1] = one
    quads[2] = two
    

	sprites["quads"] = quads

	return sprites
end

function Images.loadSliver(self)
	local sprites = {}
    sprites["image"] = love.graphics.newImage("media/sprites/effects/sliver.png")
    sprites["image"]:setFilter("nearest", "nearest")
    
    local quads = {}
	quads[1] = love.graphics.newQuad(0, 0, 16, 16, 48, 16)
	quads[2] = love.graphics.newQuad(16, 0, 8, 8, 48, 16)
	quads[3] = love.graphics.newQuad(24, 0, 8, 8, 48, 16)
	quads[4] = love.graphics.newQuad(32, 0, 8, 8, 48, 16)
	quads[5] = love.graphics.newQuad(40, 0, 8, 8, 48, 16)
	quads[6] = love.graphics.newQuad(16, 8, 8, 8, 48, 16)
	quads[7] = love.graphics.newQuad(24, 8, 8, 8, 48, 16)
	quads[8] = love.graphics.newQuad(32, 8, 8, 8, 48, 16)
	quads[9] = love.graphics.newQuad(40, 0, 8, 8, 48, 16)

	sprites["quads"] = quads

	return sprites
end

function Images.loadDummy(self)
	local sprites = {}
	sprites["image"] = love.graphics.newImage("media/sprites/enemies/dummy.png")
    sprites["image"]:setFilter("nearest", "nearest")
    
    local quads = {}
	quads[1] = love.graphics.newQuad(0, 0, 32, 64, 64, 64)
	quads[2] = love.graphics.newQuad(32, 0, 32, 64, 64, 64)
    
    sprites["quads"] = quads
    
    return sprites
end

function Images.loadAudubon(self)
	local sprites = {}
	sprites["image"] = love.graphics.newImage("media/sprites/audubon.png")
    sprites["image"]:setFilter("nearest", "nearest")
    
	local quads = {}
	local down = {}
	down[1] = love.graphics.newQuad(0, 0, 32, 64, 960, 320)
	down[2] = love.graphics.newQuad(32, 0, 32, 64, 960, 320)
	down[3] = love.graphics.newQuad(64, 0, 32, 64, 960, 320)
	down[4] = love.graphics.newQuad(96, 0, 32, 64, 960, 320)
	down[5] = love.graphics.newQuad(128, 0, 32, 64, 960, 320)
	down[6] = love.graphics.newQuad(160, 0, 32, 64, 960, 320)
	down[7] = love.graphics.newQuad(192, 0, 32, 64, 960, 320)

	local up = {}
	up[1] = love.graphics.newQuad(0, 64, 32, 64, 960, 320)
	up[2] = love.graphics.newQuad(32, 64, 32, 64, 960, 320)
	up[3] = love.graphics.newQuad(64, 64, 32, 64, 960, 320)
	up[4] = love.graphics.newQuad(96, 64, 32, 64, 960, 320)
	up[5] = love.graphics.newQuad(128, 64, 32, 64, 960, 320)
	up[6] = love.graphics.newQuad(160, 64, 32, 64, 960, 320)
	up[7] = love.graphics.newQuad(192, 64, 32, 64, 960, 320)

	local left = {}
	left[1] = love.graphics.newQuad(0, 128, 32, 64, 960, 320)
	left[2] = love.graphics.newQuad(32, 128, 32, 64, 960, 320)
	left[3] = love.graphics.newQuad(64, 128, 32, 64, 960, 320)
	left[4] = love.graphics.newQuad(96, 128, 32, 64, 960, 320)
	left[5] = love.graphics.newQuad(128, 128, 32, 64, 960, 320)
	left[6] = love.graphics.newQuad(160, 128, 32, 64, 960, 320)
	left[7] = love.graphics.newQuad(192, 128, 32, 64, 960, 320)

	local right = {}
	right[1] = love.graphics.newQuad(0, 192, 32, 64, 960, 320)
	right[2] = love.graphics.newQuad(32, 192, 32, 64, 960, 320)
	right[3] = love.graphics.newQuad(64, 192, 32, 64, 960, 320)
	right[4] = love.graphics.newQuad(96, 192, 32, 64, 960, 320)
	right[5] = love.graphics.newQuad(128, 192, 32, 64, 960, 320)
	right[6] = love.graphics.newQuad(160, 192, 32, 64, 960, 320)
	right[7] = love.graphics.newQuad(192, 192, 32, 64, 960, 320)
    
    local tool_use = {}
    local tool_use_down = {}
	tool_use_down[1] = love.graphics.newQuad(224, 0, 32, 64, 960, 320)
	tool_use_down[2] = love.graphics.newQuad(256, 0, 32, 64, 960, 320)
	tool_use_down[3] = love.graphics.newQuad(288, 0, 32, 64, 960, 320)
    local tool_use_up = {}
    tool_use_up[1] = love.graphics.newQuad(224, 64, 32, 64, 960, 320)
    tool_use_up[2] = love.graphics.newQuad(256, 64, 32, 64, 960, 320)
    tool_use_up[3] = love.graphics.newQuad(288, 64, 32, 64, 960, 320)
    local tool_use_left = {}
    tool_use_left[1] = love.graphics.newQuad(224, 128, 32, 64, 960, 320)
    tool_use_left[2] = love.graphics.newQuad(256, 128, 32, 64, 960, 320)
    tool_use_left[3] = love.graphics.newQuad(288, 128, 32, 64, 960, 320)
    local tool_use_right = {}
    tool_use_right[1] = love.graphics.newQuad(224, 192, 32, 64, 960, 320)
    tool_use_right[2] = love.graphics.newQuad(256, 192, 32, 64, 960, 320)
    tool_use_right[3] = love.graphics.newQuad(288, 192, 32, 64, 960, 320)
		
	tool_use["down"] = tool_use_down
    tool_use["up"] = tool_use_up
	tool_use["left"] = tool_use_left
    tool_use["right"] = tool_use_right
    
    local run_right = {}
    run_right[1] = love.graphics.newQuad(320, 192, 64, 64, 960, 320)
    run_right[2] = love.graphics.newQuad(384, 192, 64, 64, 960, 320)
    run_right[3] = love.graphics.newQuad(448, 192, 64, 64, 960, 320)
    run_right[4] = love.graphics.newQuad(512, 192, 64, 64, 960, 320)
    run_right[5] = love.graphics.newQuad(576, 192, 64, 64, 960, 320)
    run_right[6] = love.graphics.newQuad(640, 192, 64, 64, 960, 320)
    run_right[7] = love.graphics.newQuad(704, 192, 64, 64, 960, 320)
    run_right[8] = love.graphics.newQuad(768, 192, 64, 64, 960, 320)
    run_right[9] = love.graphics.newQuad(832, 192, 64, 64, 960, 320)
    run_right[10] = love.graphics.newQuad(896, 192, 64, 64, 960, 320)
    
    local run_left = {}
    run_left[1] = love.graphics.newQuad(320, 128, 64, 64, 960, 320)
    run_left[2] = love.graphics.newQuad(384, 128, 64, 64, 960, 320)
    run_left[3] = love.graphics.newQuad(448, 128, 64, 64, 960, 320)
    run_left[4] = love.graphics.newQuad(512, 128, 64, 64, 960, 320)
    run_left[5] = love.graphics.newQuad(576, 128, 64, 64, 960, 320)
    run_left[6] = love.graphics.newQuad(640, 128, 64, 64, 960, 320)
    run_left[7] = love.graphics.newQuad(704, 128, 64, 64, 960, 320)
    run_left[8] = love.graphics.newQuad(768, 128, 64, 64, 960, 320)
    run_left[9] = love.graphics.newQuad(832, 128, 64, 64, 960, 320)
    run_left[10] = love.graphics.newQuad(896, 128, 64, 64, 960, 320)
    
    local dodge = {}
    local dodge_down = {}
    dodge_down[1] = love.graphics.newQuad(0, 256, 32, 64, 960, 320)
    dodge_down[2] = love.graphics.newQuad(32, 256, 32, 64, 960, 320)
    local dodge_up = {}
    dodge_up[1] = love.graphics.newQuad(64, 256, 32, 64, 960, 320)
    dodge_up[2] = love.graphics.newQuad(96, 256, 32, 64, 960, 320)
    local dodge_left = {}
    dodge_left[1] = love.graphics.newQuad(128, 256, 32, 64, 960, 320)
    dodge_left[2] = love.graphics.newQuad(160, 256, 32, 64, 960, 320)
    local dodge_right = {}
    dodge_right[1] = love.graphics.newQuad(192, 256, 32, 64, 960, 320)
    dodge_right[2] = love.graphics.newQuad(224, 256, 32, 64, 960, 320)
    
    dodge["down"] = dodge_down
    dodge["up"] = dodge_up
    dodge["left"] = dodge_left
    dodge["right"] = dodge_right
    
    
	quads["down"] = down
	quads["up"] = up
	quads["left"] = left
	quads["right"] = right
	quads["tool_use"] = tool_use
	quads["run_left"] = run_left
	quads["run_right"] = run_right
	quads["dodge"] = dodge

	sprites["quads"] = quads

	return sprites
end

function Images.loadSword(self)
	local sprites = {}
    sprites["image"] = love.graphics.newImage("media/sprites/sword-weapon.png")
    sprites["image"]:setFilter("nearest", "nearest")
	local quads = {}
    
	local down = {}
	down[1] = love.graphics.newQuad(0, 0, 32, 32, 256, 128)
	down[2] = love.graphics.newQuad(32, 0, 32, 32, 256, 128)
	down[3] = love.graphics.newQuad(64, 0, 32, 32, 256, 128)
	down[4] = love.graphics.newQuad(96, 0, 32, 32, 256, 128)
	down[5] = love.graphics.newQuad(128, 0, 64, 64, 256, 128)
	down[6] = love.graphics.newQuad(192, 0, 64, 64, 256, 128)
    
	local up = {}
	up[1] = love.graphics.newQuad(0, 32, 32, 32, 256, 128)
	up[2] = love.graphics.newQuad(32, 32, 32, 32, 256, 128)
	up[3] = love.graphics.newQuad(64, 32, 32, 32, 256, 128)
	up[4] = love.graphics.newQuad(96, 32, 32, 32, 256, 128)
	up[5] = love.graphics.newQuad(128, 0, 64, 64, 256, 128)
	up[6] = love.graphics.newQuad(192, 0, 64, 64, 256, 128)
    
	local left = {}
	left[1] = love.graphics.newQuad(0, 64, 32, 32, 256, 128)
	left[2] = love.graphics.newQuad(32, 64, 32, 32, 256, 128)
	left[3] = love.graphics.newQuad(64, 64, 32, 32, 256, 128)
	left[4] = love.graphics.newQuad(96, 64, 32, 32, 256, 128)
	left[5] = love.graphics.newQuad(128, 0, 64, 64, 256, 128)
	left[6] = love.graphics.newQuad(192, 0, 64, 64, 256, 128)
	
	local right = {}
	right[1] = love.graphics.newQuad(0, 96, 32, 32, 256, 128)
	right[2] = love.graphics.newQuad(32, 96, 32, 32, 256, 128)
	right[3] = love.graphics.newQuad(64, 96, 32, 32, 256, 128)
	right[4] = love.graphics.newQuad(96, 96, 32, 32, 256, 128)
	right[5] = love.graphics.newQuad(128, 0, 64, 64, 256, 128)
	right[6] = love.graphics.newQuad(192, 0, 64, 64, 256, 128)
    
	quads["down"] = down
	quads["up"] = up
	quads["left"] = left
	quads["right"] = right
    
	sprites["quads"] = quads
	return sprites

end
