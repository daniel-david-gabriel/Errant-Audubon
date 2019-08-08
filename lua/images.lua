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
    
	self.images["attackHurt"] = self:loadSprite("attack_hurt", "media/sprites/effects/attack_hurt.png")
	
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
	
	-- tools in inventory
	self.images["sword"] = love.graphics.newImage("media/menu/tools/sword.png")
	self.images["sword"]:setFilter("nearest", "nearest")
	self.images["glove"] = love.graphics.newImage("media/menu/tools/glove.png")
	self.images["shield"] = love.graphics.newImage("media/menu/tools/shield.png")
	
	
	self.images["sword weapon"] = self:loadSprite("sword_weapon", "media/sprites/sword-weapon.png")
	
	self.images["circle"] = love.graphics.newImage("media/sprites/circle.png")
	
	self.images["amphora"] = love.graphics.newImage("media/sprites/enemies/amphora.png")
	self.images["chest"] = love.graphics.newImage("media/sprites/enemies/chest.png")

	self.images["audubon"] = self:loadAudubon()
	self.images["attackHit"] = self:loadSprite("attackHit", "media/sprites/effects/attackhit.png")
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
	while love.filesystem.getInfo("media/sprites/enemies/" .. enemyName .. "/Front-" .. tostring(i) .. ".png") do
		frontSprites[i] = love.graphics.newImage("media/sprites/enemies/" .. enemyName .. "/Front-" .. tostring(i) .. ".png")
		i = i + 1
	end
	enemySprites["front"] = frontSprites
	
	-- back
	i = 1
	local backSprites = {}
	while love.filesystem.getInfo("media/sprites/enemies/" .. enemyName .. "/Back-" .. tostring(i) .. ".png") do
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
	sprites["image"]:setFilter("nearest", "nearest")

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
	quads[1] = love.graphics.newQuad(0, 0, 16, 16, 32, 16)
	quads[2] = love.graphics.newQuad(16, 0, 16, 16, 32, 16)
	--quads[1] = love.graphics.newQuad(0, 0, 32, 32, 64, 32)
	--quads[2] = love.graphics.newQuad(32, 0, 32, 32, 64, 32)
	
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
	sprites["quads"] = getQuadsFromSlices("bigSlime", sprites["image"]:getWidth(), sprites["image"]:getHeight())
	
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
	sprites["quads"] = getQuadsFromSlices("audubon", sprites["image"]:getWidth(), sprites["image"]:getHeight())
	
	return sprites
end

function Images.loadSprite(self, name, img)
	local sprites = {}
	sprites["image"] = love.graphics.newImage(img)
    sprites["image"]:setFilter("nearest", "nearest")
	sprites["quads"] = getQuadsFromSlices(name, sprites["image"]:getWidth(), sprites["image"]:getHeight())
	
	return sprites
end

function getQuadsFromSlices(spriteName, imgWidth, imgHeight)
	local quads = {}
	local myTables = split(love.filesystem.read("media/sprites/slices/" .. spriteName), "%S+")
	local arr = json.decode(myTables[1])
	local arrNames = json.decode(myTables[2])
	
	for i=1,table.getn(arrNames) do
    	local newTable = {}
    	if table.getn(arrNames[i]) > 1 then			--sub groups
    		for index,value in ipairs(arr[i]) do
    			local newTable2 = {}
    			for index2,value2 in ipairs(value) do
    				newTable2[index2] = love.graphics.newQuad(value2[1], value2[2], value2[3], value2[4], imgWidth, imgHeight);
    			end
    			newTable[arrNames[i][index+1]] = newTable2
    		end
    		quads[arrNames[i][1]] = newTable 
    		
    	else										--no sub groups
    		for index,value in ipairs(arr[i]) do
    			newTable[index] = love.graphics.newQuad(value[1], value[2], value[3], value[4], imgWidth, imgHeight)
    		end
    		quads[arrNames[i][1]] = newTable 
    	end
    end
    
    return quads
end
















