require("lua/sprites/sprite")
require("lua/sprites/hud")
require("lua/journalentry")
require("lua/sprites/tools/sword")
require("lua/sprites/tools/glove")
require("lua/sprites/tools/shield")

Knight = {}
Knight.__index = Knight


setmetatable(Knight, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Knight:_init()
	Sprite._init(self, 11*32,16*32, 32, 32)

	self.hud = Hud(self)
	self.health = 100

	self.upPressed = false
	self.downPressed = false
	self.leftPressed = false
	self.rightPressed = false
	self.hasMoved = false
	self.facingDirection  = "down"
	
	self.tool = nil
	self.toolPressed = false
	self.subtool = nil
	self.subtoolPressed = false	

	self.speed = 4
	self.spriteName = "audubon"
	self.spriteCounter = 1
	self.spriteTimer = 0

	self.isGrabbing = false
	self.grabbedEnemy = nil

	-- save data
	self.money = 0
	self.area = 0
	self.tools = self:initializeTools()
	self.journal = self:initializeJournal()
	self.flags = self:initializeFlags()
end

function Knight.draw(self)
	if options.debug then
		love.graphics.setColor(0, 0, 0, 128)
		love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	end
	love.graphics.setColor(255, 255, 255, 255)
	local sprites = images:getImage(self.spriteName)
	love.graphics.draw(sprites["image"], sprites["quads"][self.facingDirection][self.spriteCounter], (self.x)-32, (self.y)-64)

	if not (self.tool == nil) then
		self.tool:draw()
	end

	self.hud:draw(self)
end

function Knight.keypressed(self, key)
	if key == keyBindings:getUp() then
		self.upPressed = true
		self.facingDirection = "up"
	end
	if key == keyBindings:getLeft() then
		self.leftPressed = true
		self.facingDirection = "left"
	end
	if key == keyBindings:getDown() then
		self.downPressed = true
		self.facingDirection = "down"
	end
	if key == keyBindings:getRight() then
		self.rightPressed = true
		self.facingDirection = "right"
	end
	if key == keyBindings:getTool() then
		self.toolPressed = true
	end
	if key == keyBindings:getSubtool() then
		self.subtoolPressed = true
	end
end

function Knight.keyreleased(self, key)
	if self.hasMoved then
		self.hasMoved = false
	end

	if key == keyBindings:getUp() then
		self.upPressed = false
	end
	if key == keyBindings:getLeft() then
		self.leftPressed = false
	end
	if key == keyBindings:getDown() then
		self.downPressed = false
	end
	if key == keyBindings:getRight() then
		self.rightPressed = false
	end
	if key == keyBindings:getTool() then
		self.toolPressed = false
	end
	if key == keyBindings:getSubtool() then
		self.subtoolPressed = false
	end
	
	if self.upPressed then
		self.facingDirection = "up"
	end
	if self.leftPressed then
		self.facingDirection = "left"
	end
	if self.downPressed then
		self.facingDirection = "down"
	end
	if self.rightPressed then
		self.facingDirection = "right"
	end
end

function Knight.resetKeys(self)
	self.upPressed = false
	self.downPressed = false
	self.leftPressed = false
	self.rightPressed = false
end

function Knight.update(self, dt)

	self.hud:update(dt, self)

	if not (self.tool == nil) then
		self.tool:update(dt)
	end

	if not (self.subtool == nil) then
		self.subtool:update(dt)
	end

	if self.toolPressed then
		if table.getn(map.npcs) > 0 then
			local speechSprite
			if self.facingDirection == "up" then
				speechSprite = Sprite(self.x, self.y-32, 32, 32)
			elseif self.facingDirection == "down" then
				speechSprite = Sprite(self.x, self.y+32, 32, 32)
			elseif self.facingDirection == "left" then
				speechSprite = Sprite(self.x-32, self.y, 32, 32)
			elseif self.facingDirection == "right" then
				speechSprite = Sprite(self.x+32, self.y, 32, 32)
			end
			for i,npc in pairs(map.npcs) do
				if speechSprite:collidesWith(npc) then
					npc:interact()
					self.toolPressed = false
					self.hasMoved = true
					return
				end
			end
			for i,shopkeeper in pairs(map.shopkeepers) do
				if speechSprite:collidesWith(shopkeeper) then
					shopkeeper:interact()
					self.toolPressed = false
					self.hasMoved = true
					return
				end
			end
		elseif not (self.tool == nil) then
			self.tool:use(self)
			self.toolPressed = false
			
		end
	end
	if self.subtoolPressed then
		if not (self.subtool == nil) then
			self.subtool:use(self)
			self.subtoolPressed = false
		end
	end

	if self.isGrabbing and self.grabbedEnemy.size == "large" then
		self.x = self.grabbedEnemy.x + math.abs(self.width - self.grabbedEnemy.width)/2
		self.y = self.grabbedEnemy.y + math.abs(self.height - self.grabbedEnemy.height)/2

		self.xPos = math.floor(self.x / 32)
		self.yPos = math.floor(self.y / 32)
		return
	elseif self.isGrabbing and self.grabbedEnemy.size == "small" then
		--do nothing?
	end

	local speed = self.speed
	if (self.upPressed or self.downPressed) and (self.leftPressed or self.rightPressed) then
		speed = speed / 1.4 -- ~sqrt(2)
	end

	if self.upPressed then
		self:move("up", speed)
		self.hasMoved = true
	elseif self.downPressed then
		self:move("down", speed)
		self.hasMoved = true
	end
	if self.leftPressed then
		self:move("left", speed)
		self.hasMoved = true
	elseif self.rightPressed then
		self:move("right", speed)
		self.hasMoved = true
	end

	self.spriteTimer = self.spriteTimer + dt
	if self.hasMoved and self.spriteTimer > .15 then
		self.spriteCounter = self.spriteCounter + 1
		self.spriteTimer = 0
		if self.spriteCounter > 4 then
			self.spriteCounter = 1
		end
	end

end

function Knight.knockback(self, other, damage)
	if self.isGrabbing and self.grabbedEnemy.size == "large" then
		return
	end

	self:damage(damage)
	if self.facingDirection == "up" then
		self:move("down", 16)
		self.hasMoved = true
	elseif self.facingDirection == "down" then
		self:move("up", 16)
		self.hasMoved = true
	elseif self.facingDirection == "left" then
		self:move("right", 16)
		self.hasMoved = true
	elseif self.facingDirection == "right" then
		self:move("left", 16)
		self.hasMoved = true
	end
end

function Knight.damage(self, amount)
	self.health = self.health - amount

	if self.health <= 0 then
		self.health = 0
		self:die()
	end
end

function Knight.heal(self, amount)
	self.health = self.health + amount

	if self.health > 100 then
		self.health = 100
	end
end

function Knight.die(self)
	local necromancerPact = self.flags["necromancer"]

	if necromancerPact < 1 then
		toState = GameOver()
	elseif necromancerPact < 2 then
		toMap = maps["Nexus-001"]
		self.x = 11 * 32
		self.y = 10 * 32
		
		self.health = 100
	--elseif necromancerPact < 3 then
	else
		toMap = maps["Nexus-002"]
		self.x = 11 * 32
		self.y = 10 * 32
		
		self.health = 100
	end
end

function Knight.initializeTools(self)
	local tools = {}

	tools["sword"] = Sword()
	tools["glove"] = Glove()
	tools["shield"] = Shield()

	return tools
end

function Knight.initializeJournal(self)

	local journal = {}
	journal["blackbell"] = JournalEntry("blackbell", 0, 0, 0)
	journal["archer"] = JournalEntry("archer", 0, 0, 0)
	journal["slime"] = JournalEntry("slime", 0, 0, 0)
	journal["minispider"] = JournalEntry("minispider", 0, 0, 0)
	journal["bigslime"] = JournalEntry("bigslime", 0, 0, 0)
	journal["bat"] = JournalEntry("bat", 0, 0, 0)
	journal["potSpider"] = JournalEntry("potSpider", 0, 0, 0)
	journal["amphora"] = JournalEntry("amphora", 0, 0, 0)
	return journal
end

function Knight.initializeFlags(self)
	local flags = {}

	flags["game"] = 1
	flags["town"] = 1
	flags["necromancer"] = 0
	flags["yome"] = 1

	return flags
end
