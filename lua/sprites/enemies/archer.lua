require("lua/sprites/enemy")

Archer = {}
Archer.__index = Archer


setmetatable(Archer, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Archer:_init(x, y)
	Enemy._init(self, x, y, 32, 32)

	self.image = images:getImage("archer")
	self.name = "archer"

	self.common = "feather"
	self.uncommon = "eye"
	self.rare = "tuft"

	self.speed = 2
	self.bulletTimer = 0

	self.health = 2
end

function Archer.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.image, (self.x)-32, (self.y)-32, math.rad(0), 1, 1, 0, self.height)
end

function Archer.update(self, map, dt)

	if self:collidesWith(knight) then
		knight:knockback(self, 10)
	end

	self.bulletTimer = self.bulletTimer + dt
	if self:isInRange(knight) then
		if self.bulletTimer > 5 then
			self:fireBullet(map)
			self.bulletTimer = 0
		end
	elseif self:isLeftOf(knight) then
		self:move("right", self.speed)
	elseif self:isRightOf(knight) then
		self:move("left", self.speed)
	elseif self:isAbove(knight) then
		self:move("down", self.speed)
	elseif self:isBelow(knight) then
		self:move("up", self.speed)
	end
end

function Archer.isInRange(self, other)
	local isInXRange = math.abs(self.xPos - other.xPos) < 3
	local isInYRange = math.abs(self.yPos - other.yPos) < 3
	return isInXRange and isInYRange
end

function Archer.fireBullet(self, map)
	local x = self.x
	local y = self.y
	if self:isLeftOf(knight) then
		table.insert(map.bullets, Arrow(x, y, "right"))
	elseif self:isRightOf(knight) then
		table.insert(map.bullets, Arrow(x, y, "left"))
	elseif self:isAbove(knight) then
		table.insert(map.bullets, Arrow(x, y, "down"))
	elseif self:isBelow(knight) then
		table.insert(map.bullets, Arrow(x, y, "up"))
	end
end
