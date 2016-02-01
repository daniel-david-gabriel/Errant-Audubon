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

	self.images["bullet"] = love.graphics.newImage("media/sprites/bullet.png")
	self.images["arrow"] = love.graphics.newImage("media/sprites/arrow.png")
	self.images["archer"] = love.graphics.newImage("media/sprites/archer.png")
	self.images["turret"] = love.graphics.newImage("media/sprites/turret.png")

	self.images["blackbell"] = self:loadEnemySprites("blackbell")
	self.images["slime"] = self:loadEnemySprites("slime")
	self.images["minispider"] = self:loadMinispider()
	self.images["bigslime"] = love.graphics.newImage("media/sprites/enemies/bigslime/sprites.png")
	self.images["bat"] = self:loadBat()
	self.images["potSpider"] = self:loadPotSpider()

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
	self.images["glove"] = love.graphics.newImage("media/menu/tools/glove.png")
	self.images["shield"] = love.graphics.newImage("media/menu/tools/shield.png")
	
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

function Images.loadAudubon(self)
	local sprites = {}
	sprites["image"] = love.graphics.newImage("media/sprites/audubon.png")

	local quads = {}
	local down = {}
	down[1] = love.graphics.newQuad(0, 0, 32, 64, 96, 256)
	down[2] = love.graphics.newQuad(32, 0, 32, 64, 96, 256)
	down[3] = love.graphics.newQuad(64, 0, 32, 64, 96, 256)
	down[4] = love.graphics.newQuad(32, 0, 32, 64, 96, 256)
	down[5] = love.graphics.newQuad(64, 0, 32, 64, 96, 256)
	down[6] = love.graphics.newQuad(32, 0, 32, 64, 96, 256)

	local up = {}
	up[1] = love.graphics.newQuad(0, 64, 32, 64, 96, 256)
	up[2] = love.graphics.newQuad(32, 64, 32, 64, 96, 256)
	up[3] = love.graphics.newQuad(64, 64, 32, 64, 96, 256)
	up[4] = love.graphics.newQuad(64, 64, 32, 64, 96, 256)
	up[5] = love.graphics.newQuad(64, 64, 32, 64, 96, 256)
	up[6] = love.graphics.newQuad(32, 64, 32, 64, 96, 256)

	local left = {}
	left[1] = love.graphics.newQuad(0, 128, 32, 64, 96, 256)
	left[2] = love.graphics.newQuad(32, 128, 32, 64, 96, 256)
	left[3] = love.graphics.newQuad(64, 128, 32, 64, 96, 256)
	left[4] = love.graphics.newQuad(64, 128, 32, 64, 96, 256)
	left[5] = love.graphics.newQuad(64, 128, 32, 64, 96, 256)
	left[6] = love.graphics.newQuad(32, 128, 32, 64, 96, 256)

	local right = {}
	right[1] = love.graphics.newQuad(0, 192, 32, 64, 96, 256)
	right[2] = love.graphics.newQuad(32, 192, 32, 64, 96, 256)
	right[3] = love.graphics.newQuad(64, 192, 32, 64, 96, 256)
	right[4] = love.graphics.newQuad(64, 192, 32, 64, 96, 256)
	right[5] = love.graphics.newQuad(64, 192, 32, 64, 96, 256)
	right[6] = love.graphics.newQuad(32, 192, 32, 64, 96, 256)

	quads["down"] = down
	quads["up"] = up
	quads["left"] = left
	quads["right"] = right

	sprites["quads"] = quads

	return sprites
end
